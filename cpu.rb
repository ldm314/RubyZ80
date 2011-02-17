require 'math8'

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
  attr_accessor :ix
  attr_accessor :iy
  attr_accessor :i
  attr_accessor :r
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
    @ix =0
    @iy =0
    @i = 0
    @r = 0
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