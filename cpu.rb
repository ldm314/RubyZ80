require 'ops'

class Z80clock
  attr_accessor :m
  attr_accessor :t
  def initialize
    @m = 0
    @t = 0
  end
end

class Z80registers
  attr_accessor :a
  attr_accessor :b
  attr_accessor :c
  attr_accessor :d
  attr_accessor :e
  attr_accessor :h
  attr_accessor :l
  attr_accessor :f
  attr_accessor :pc
  attr_accessor :sp
  attr_accessor :m
  attr_accessor :t
  
  def initialize
    @a = 0
    @b = 0
    @c = 0
    @d = 0
    @e = 0
    @h = 0
    @l = 0
    @f = 0
    @pc =0
    @sp =0
    @m = 0
    @t = 0
  end
  
end

class Z80memory
  def initialize
    @memory = Array.new(65536,0)
  end
  
  def rb(addr)
    @memory[addr]
  end
  
  def wb(addr,value)
    @memory[addr] = value
  end
  
  def load(mem)
    i = 0
    mem.each { |x| @memory[i] = x; i+=1; }
  end
end

class Z80cpu
  attr_accessor :clock
  attr_accessor :registers
  attr_accessor :memory
  SIGN = 128
  ZERO = 64
  HC = 16
  
  OVER = 4
  SUB = 2
  CARRY = 1
  
  def initialize
    @clock = Z80clock.new
    @registers = Z80registers.new
    @memory = Z80memory.new
    @halted = false
  end

  def add_flags(a, old_x, old_y, carry)
    f = 0                              # Clear flags
    f = f | SIGN  if (a & SIGN) != 0  # sign
    f = f | ZERO  if (a & 255) == 0   # Check for zero
    f = f | HC if ((old_x & 15) + (old_y & 15) + (carry & 15)) > 15 #half carry
    f = f | CARRY if old_x + old_y + carry  > 255     # carry
    f = f | OVER if ((old_x & SIGN) ==  (old_y & SIGN)) && ((a & SIGN) != (old_x & SIGN))      # Check for overflow
    f
  end

  # addr_x
   
  def addr_a(carry = 0)
    a = @registers.a
    x = @registers.a
    @registers.a += x + carry                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def addr_b(carry = 0)
    a = @registers.a
    x = @registers.b
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def addr_c(carry = 0)
    a = @registers.a
    x = @registers.c
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def addr_d(carry = 0)
    a = @registers.a
    x = @registers.d
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def addr_e(carry = 0)
    a = @registers.a
    x = @registers.e
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def addr_h(carry = 0)
    a = @registers.a
    x = @registers.h
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def addr_l(carry = 0)
    a = @registers.a
    x = @registers.l
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  
  def addn(carry = 0)
    a = @registers.a
    x = @memory.rb[@registers.pc]
    @registers.pc = @registers.pc + 1
    @registers.a += x + carry                           # Perform addition
    @registers.a = @registers.a & 255                   # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 2
    @registers.t = 7                # 2 M taken
  end
  
  def adcr_a; addr_a(@registers.f & Z80cpu.CARRY); end
  def adcr_b; addr_b(@registers.f & Z80cpu.CARRY); end
  def adcr_c; addr_c(@registers.f & Z80cpu.CARRY); end
  def adcr_d; addr_d(@registers.f & Z80cpu.CARRY); end
  def adcr_e; addr_e(@registers.f & Z80cpu.CARRY); end
  def adcr_h; addr_h(@registers.f & Z80cpu.CARRY); end
  def adcr_l; addr_l(@registers.f & Z80cpu.CARRY); end

  def halt
    @halted = true
  end
  
  def load(mem)
    @memory.load(mem)
  end

  def run
    while not @halted do
      op = @memory.rb[@registers.pc]
      @registers.pc += 1
      execute(op)
      @registers.pc = @registers.pc & 65535
      @clock.m += @registers.m
      @clock.t += @registers.t
    end
  end
  
end