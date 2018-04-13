class DosHeader
    attr_reader :last_page_size
    attr_reader :num_pages
    attr_reader :num_relocation_entries
    attr_reader :header_size
    attr_reader :minimum_memory_required
    attr_reader :memory_requested
    attr_reader :initial_ss
    attr_reader :initial_sp
    attr_reader :checksum
    attr_reader :initial_ip
    attr_reader :initial_cs
    attr_reader :relocation_table_offset
    attr_reader :overlay_number

  def initialize(packed_signature,
      last_page_size,
      num_pages,
      num_relocation_entries,
      header_size,
      minimum_memory_required,
      memory_requested,
      initial_ss,
      initial_sp,
      checksum,
      initial_ip,
      initial_cs,
      relocation_table_offset,
      overlay_number)
    @packed_signature = packed_signature
    @last_page_size = last_page_size
    @num_pages = num_pages
    @num_relocation_entries = num_relocation_entries
    @header_size = header_size
    @minimum_memory_required = minimum_memory_required
    @memory_requested = memory_requested
    @initial_ss = initial_ss
    @initial_sp = initial_sp
    @checksum = checksum
    @initial_ip = initial_ip
    @initial_cs = initial_cs
    @relocation_table_offset = relocation_table_offset
    @overlay_number = overlay_number
  end

  def signature
    [@packed_signature].pack("<S")
  end

  def pack
    [
      @packed_signature,
      @last_page_size,
      @num_pages,
      @num_relocation_entries,
      @header_size,
      @minimum_memory_required,
      @memory_requested,
      @initial_ss,
      @initial_sp,
      @checksum,
      @initial_ip,
      @initial_cs,
      @relocation_table_offset,
      @overlay_number
    ].pack("<S" * 14)
  end

  def self.unpack(serialised_dos_header)
    args = serialised_dos_header.unpack("<S" * 14)
    new(*args)
  end
end