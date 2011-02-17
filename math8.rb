module Z80ops
  ADDA_A = 0x87
  ADDA_B = 0x80
  ADDA_C = 0x81
  ADDA_D = 0x82
  ADDA_E = 0x83
  ADDA_H = 0x84
  ADDA_L = 0x85
  ADDA_HL = 0x86
  ADDA_N = 0xC6

  ADCA_A = 0x87 + 8
  ADCA_B = 0x80 + 8
  ADCA_C = 0x81 + 8
  ADCA_D = 0x82 + 8
  ADCA_E = 0x83 + 8
  ADCA_H = 0x84 + 8
  ADCA_L = 0x85 + 8
  ADCA_HL = 0x86 + 8
  ADCA_N = 0xC6 + 8
  
  #todo, ops with IX, IY 
  
end

class Z80cpu

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
   
  def adda_a(carry = 0)
    a = @registers.a
    x = @registers.a
    @registers.a += x + carry                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def adda_b(carry = 0)
    a = @registers.a
    x = @registers.b
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def adda_c(carry = 0)
    a = @registers.a
    x = @registers.c
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def adda_d(carry = 0)
    a = @registers.a
    x = @registers.d
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def adda_e(carry = 0)
    a = @registers.a
    x = @registers.e
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def adda_h(carry = 0)
    a = @registers.a
    x = @registers.h
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def adda_l(carry = 0)
    a = @registers.a
    x = @registers.l
    @registers.a += x + carry                               # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  
  def adda_n(carry = 0)
    a = @registers.a
    x = @memory.rb[@registers.pc]
    @registers.pc = @registers.pc + 1
    @registers.a += x + carry                           # Perform addition
    @registers.a = @registers.a & 255                   # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 2
    @registers.t = 7                # 2 M taken
  end
  
  def adda_hl(carry = 0)
    a = @registers.a
    x = @memory.rb[((@registers.h << 8) & 0xF0) | ((@registers.l << 8) & 0x0F)]
    @registers.a += x + carry                           # Perform addition
    @registers.a = @registers.a & 255                   # Mask to 8-bits
    @registers.f = add_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 2
    @registers.t = 7                # 2 M taken
  end
  
  def adca_a; adda_a(@registers.f & Z80cpu.CARRY); end
  def adca_b; adda_b(@registers.f & Z80cpu.CARRY); end
  def adca_c; adda_c(@registers.f & Z80cpu.CARRY); end
  def adca_d; adda_d(@registers.f & Z80cpu.CARRY); end
  def adca_e; adda_e(@registers.f & Z80cpu.CARRY); end
  def adca_h; adda_h(@registers.f & Z80cpu.CARRY); end
  def adca_l; adda_l(@registers.f & Z80cpu.CARRY); end
  def adca_n; adda_n(@registers.f & Z80cpu.CARRY); end
  def adca_h1; adda_hl(@registers.f & Z80cpu.CARRY); end
  
end