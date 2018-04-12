def unpack_lz91(file)
  
end

input_filename, output_filename = ARGV

File.open(input_filename, "r") do |file|
  file.seek(0x20)
  unpack_lz91(file)
end