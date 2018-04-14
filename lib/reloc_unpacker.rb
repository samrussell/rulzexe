class RelocUnpacker
  def initialize(file)
    @file = file
    @output = []
  end

  def unpack
    segment = 0
    offset = 0
    while true
      increment, = @file.read(1).unpack("C")
      
      if increment == 0
        increment, = @file.read(2).unpack("<S")
        if increment == 0
          segment = (segment + 0xFFF) % 0x10000
          next
        elsif increment == 1
          break
        end
      end

      intermediate = offset + increment
      segment += (intermediate >> 4)
      offset = intermediate & 0xF
      @output.push([offset, segment].pack("<S<S"))
    end

    @output.join
  end
end