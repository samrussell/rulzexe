require "./lib/code_unpacker.rb"

describe CodeUnpacker do
  let(:unpacked_data) do
    "\xBA\x05\x13.\x89\x165\x02\xB40\xCD!\x8B.\x02\x00\x8B\x1E,\x00\x8E\xDA\xA3\x90\x00\x8C\x06\x8E\x00\x89\x1E\x8A\x00\x89.\xA6\x00\xE8=\x01\xC4>\x88\x00\x8B\xC7\x8B\xD8\xB9\xFF\x7F\xFC\xF2\xAE\xE3aC&8\x05u\xF6\x80\xCD\x80\xF7\xD9\x89\x0E\x88\x00\xB9\x01\x00\xD3\xE3\x83\xC3\b\x83\xE3\xF8\x89\x1E\x8C\x00\x8C\xDA+\xEA\x8B>LU\x81\xFF\x00\x02s\a".force_encoding("ASCII-8BIT")
  end

  let(:packed_data) do
    "\xFF\xFF\xBA\x05\x13.\x89\x165\x02\xB40\xCD!\x8B.\x02\xFF\xFF\x00\x8B\x1E,\x00\x8E\xDA\xA3\x90\x00\x8C\x06\x8E\x00\x89\x1E\xF0\x1F\x8A\xFC.\xA6\x00\xE8=\x01\xC4>\x88\xFE\xFF\xE4\xC7\x8B\xD8\xB9\xFF\x7F\xFC\xF2\xAE\xE3aC&8\xFF\xE1\x05u\xF6\x80\xCD\x80\xF7\xD9\x89\x0E\xE5\xB9\x01\xFF\x10\x00\xD3\xE3\x83\xC3\b\x83\xE3\xF8\xCB\x8C\xFE\x7F\xC3\xDA+\xEA\x8B".force_encoding("ASCII-8BIT")
  end
end