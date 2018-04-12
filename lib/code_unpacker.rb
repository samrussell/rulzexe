class Flags
  def initialize(file)
    @file = file
    @bits = []
  end

  def topup
    data = @file.read(2)
    word = data.unpack("<S")[0]
    @bits = 16.times.map do |shift|
      (word >> shift) & 0x01
    end
  end

  def get_bit
    bit = @bits.shift

    topup if empty?

    bit
  end

  def empty?
    @bits.empty?
  end
end

class CodeUnpacker
  def initialize(file)
    @file = file
    @flags = Flags.new(file)
    @output = []
  end

  def unpack
    @flags.topup

    while true
      bit = @flags.get_bit
      if bit == 1
        @output.push(@file.read(1))
      else
        bit = @flags.get_bit
        if bit == 0
          bits = 2.times.map { @flags.get_bit }
          length = (bits[0] << 1) + bits[1] + 2
          distance = @file.read(1).unpack("C")[0] - 0x100 # lets us go to -255
          copy(distance, length)
        else
          # parse 2 bytes
          low_byte, high_byte = @file.read(2).unpack("CC")
          pre_length = high_byte & 0x07
          distance = ((high_byte & 0xF8) << 5) + low_byte - 0x2000
          if pre_length > 0
            length = pre_length + 2
            copy(distance, length)
          else
            pre_length = @file.read(1).unpack("C")[0]
            if pre_length == 0
              break
            elsif pre_length > 1
              length = pre_length + 1
              copy(distance, length)
            end
          end
        end
      end
    end

    @output.join
  end

  private

  def copy(distance, length)
    current_offset = @output.length
    length.times do |offset|
      byte = @output[current_offset + distance + offset]
      @output.push(byte)
    end
  end
end