require "./lib/code_unpacker.rb"

input_filename, output_filename = ARGV

File.open(input_filename, "r") do |input_file|
  input_file.seek(0x20)
  unpacked_data = CodeUnpacker.new(input_file).unpack
  
  File.open(output_filename, "w") do |output_file|
    output_file.write(unpacked_data)
  end
end