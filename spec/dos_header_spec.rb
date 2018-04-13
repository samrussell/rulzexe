require "./lib/dos_header.rb"

describe DosHeader do
  let(:serialised_dos_header) do
    "\x4D\x5A\xF6\x01\x64\x00\x00\x00\x02\x00\x9F\x11\xFF\xFF\x92\x18\x80\x00\x00\x00\x0E\x00\x66\x0C\x1C\x00\x00\x00".force_encoding("ASCII-8BIT")
  end

  describe ".unpack" do
    let(:header) { DosHeader.unpack(serialised_dos_header) }

    it "unpacks the header correctly and moves the file pointer to the end" do
      expect(header.signature).to eq("MZ")
      expect(header.last_page_size).to eq(0x1F6)
      expect(header.num_pages).to eq(0x64)
      expect(header.num_relocation_entries).to eq(0)
      expect(header.header_size).to eq(2)
      expect(header.minimum_memory_required).to eq(0x119F)
      expect(header.memory_requested).to eq(0xFFFF)
      expect(header.initial_ss).to eq(0x1892)
      expect(header.initial_sp).to eq(0x0080)
      expect(header.checksum).to eq(0)
      expect(header.initial_ip).to eq(0x000E)
      expect(header.initial_cs).to eq(0x0C66)
      expect(header.relocation_table_offset).to eq(0x001C)
      expect(header.overlay_number).to eq(0)
    end
  end

  describe "#pack" do
    let(:header) do
      DosHeader.new(
        0x5A4D,
        0x1F6,
        0x64,
        0,
        2,
        0x119F,
        0xFFFF,
        0x1892,
        0x0080,
        0,
        0x000E,
        0x0C66,
        0x001C,
        0
        )
    end

    it "packs the header correctly" do
      expect(header.pack).to eq(serialised_dos_header)
    end
  end
end