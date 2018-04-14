require "./lib/code_unpacker.rb"
require "./lib/reloc_unpacker.rb"
require "./lib/dos_header.rb"

input_filename, output_filename = ARGV

File.open(input_filename, "r") do |input_file|
  serialised_dos_header = input_file.read(28)
  dos_header = DosHeader.unpack(serialised_dos_header)
  lz_marker = input_file.read(4)

  raise "Expected LZ91 marker, got #{lz_marker}" unless lz_marker == "LZ91"

  code_start = input_file.tell

  # unpack code section
  unpacked_code = CodeUnpacker.new(input_file).unpack

  code_end = input_file.tell

  packed_code_length = code_end - code_start

  # unpack relocs

  lz_loader_offset = code_start + (0x10 * dos_header.initial_cs)

  input_file.seek(lz_loader_offset)

  initial_ip, initial_cs, initial_sp, initial_ss = input_file.read(8).unpack("<S<S<S<S")

  input_file.seek(lz_loader_offset + 0x158)

  unpacked_relocs = RelocUnpacker.new(input_file).unpack

  num_relocs = unpacked_relocs.length / 4

  header_size = 0x1C + (num_relocs * 4)

  header_paragraph_size = header_size / 0x10
  header_paragraph_size += 1 if (header_size % 0x10) > 0

  file_size = unpacked_code.length + header_size

  last_page_size = file_size % 0x200
  num_pages = file_size / 0x200
  num_pages += 1 if last_page_size > 0

  memory_growth = unpacked_code.length - packed_code_length

  minimum_memory_required = dos_header.minimum_memory_required - (memory_growth / 0x10) # check if we have the remainder edge bug

  # build new dos header
  output_dos_header = DosHeader.new(
      0x5A4D,
      last_page_size,
      num_pages,
      num_relocs,
      header_paragraph_size,
      minimum_memory_required,
      0xFFFF, #memory_requested,
      initial_ss,
      initial_sp,
      0, #checksum,
      initial_ip,
      initial_cs,
      0x1C, #relocation_table_offset,
      0, #overlay_number
    )  

  File.open(output_filename, "w") do |output_file|
    output_file.write(output_dos_header.pack)
    output_file.write(unpacked_relocs)
    output_file.write(unpacked_code)
  end
end