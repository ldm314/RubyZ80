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
  ADCA_A = 0x8F
  ADCA_B = 0x88
  ADCA_C = 0x89
  ADCA_D = 0x8A
  ADCA_E = 0x8B
  ADCA_H = 0x8C
  ADCA_L = 0x8D
  ADCA_HL = 0x8E
  ADCA_N = 0xCE 
  SUBA_A = 0x97
  SUBA_B = 0x90
  SUBA_C = 0x91
  SUBA_D = 0x92
  SUBA_E = 0x93
  SUBA_H = 0x94
  SUBA_L = 0x95
  SUBA_HL = 0x96
  SUBA_N = 0xD6
  SBCA_A = 0x9F
  SBCA_B = 0x98
  SBCA_C = 0x99
  SBCA_D = 0x9A
  SBCA_E = 0x9B
  SBCA_H = 0x9C
  SBCA_L = 0x9D
  SBCA_HL = 0x9E
  SBCA_N = 0xDE
  ANDA_A = 0xA7
  ANDA_B = 0xA0
  ANDA_C = 0xA1
  ANDA_D = 0xA2
  ANDA_E = 0xA3
  ANDA_H = 0xA4
  ANDA_L = 0xA5
  ANDA_HL = 0xA6
  ANDA_N = 0xE6
  
  #todo, ops with IX, IY 
  
end

class Z80cpu

  def add_flags(a, old_x, old_y, carry)
    f = 0                              # Clear flags
    f = f | SIGN  if (a & SIGN) != 0  # sign
    f = f | ZERO  if (a & 0xFF) == 0   # Check for zero
    f = f | HC if ((old_x & 0xF) + (old_y & 0xF) + carry) > 15 #half carry
    f = f | CARRY if old_x + old_y + carry  > 255     # carry
    f = f | OVER if ((old_x & SIGN) ==  (old_y & SIGN)) && ((a & SIGN) != (old_x & SIGN))      # Check for overflow
    f
  end

  def sub_flags(a, old_x, old_y, carry)
    f = SUB
    f = f | SIGN  if (a & SIGN) != 0  # sign
    f = f | ZERO  if (a & 255) == 0   # Check for zero
    f = f | HC if ((old_y & 0xF) + carry ) > (old_x & 0xF) #half carry
    f = f | CARRY if (old_y + carry) > old_x
    f = f | OVER if ((old_x & SIGN) != (old_y & SIGN)) && ((a & SIGN) != (old_x & SIGN))
    f
  end
  
  def logic_flags(a)
    f = HC
    f = f | SIGN  if (a & SIGN) != 0  # sign
    f = f | ZERO  if (a & 255) == 0   # Check for zero
    f = f | OVER  if !a.to_s(2).count('1').odd?
    f
  end
  
  
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

  def suba_a(carry = 0)
    a = @registers.a
    x = @registers.a
    @registers.a -= (x + carry)                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
   
  def suba_b(carry = 0)
    a = @registers.a
    x = @registers.b
    @registers.a -= (x + carry)                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
   
  def suba_c(carry = 0)
    a = @registers.a
    x = @registers.c
    @registers.a -= (x + carry)                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
   
  def suba_d(carry = 0)
    a = @registers.a
    x = @registers.d
    @registers.a -= (x + carry)                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
   
  def suba_e(carry = 0)
    a = @registers.a
    x = @registers.e
    @registers.a -= (x + carry)                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
   
  def suba_h(carry = 0)
    a = @registers.a
    x = @registers.h
    @registers.a -= (x + carry)                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
   
  def suba_l(carry = 0)
    a = @registers.a
    x = @registers.l
    @registers.a -= (x + carry)                       # Perform addition
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end

  def suba_n(carry = 0)
    a = @registers.a
    x = @memory.rb[@registers.pc]
    @registers.pc = @registers.pc + 1
    @registers.a -= (x + carry)                           # Perform addition
    @registers.a = @registers.a & 255                   # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 2
    @registers.t = 7                # 2 M taken
  end
  
  def suba_hl(carry = 0)
    a = @registers.a
    x = @memory.rb[((@registers.h << 8) & 0xF0) | ((@registers.l << 8) & 0x0F)]
    @registers.a -= (x + carry)                           # Perform addition
    @registers.a = @registers.a & 255                   # Mask to 8-bits
    @registers.f = sub_flags(@registers.a,a,x,carry)    # calculate flags
    @registers.m = 2
    @registers.t = 7                # 2 M taken
  end   

  def sbca_a; suba_a(@registers.f & Z80cpu.CARRY); end
  def sbca_b; suba_b(@registers.f & Z80cpu.CARRY); end
  def sbca_c; suba_c(@registers.f & Z80cpu.CARRY); end
  def sbca_d; suba_d(@registers.f & Z80cpu.CARRY); end
  def sbca_e; suba_e(@registers.f & Z80cpu.CARRY); end
  def sbca_h; suba_h(@registers.f & Z80cpu.CARRY); end
  def sbca_l; suba_l(@registers.f & Z80cpu.CARRY); end
  def sbca_n; suba_n(@registers.f & Z80cpu.CARRY); end
  def sbca_hl; suba_hl(@registers.f & Z80cpu.CARRY); end

  def anda_a(carry = 0)
    a = @registers.a
    x = @registers.a
    @registers.a = a & x                     
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def anda_b(carry = 0)
    a = @registers.a
    x = @registers.b
    @registers.a = a & x                     
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def anda_c(carry = 0)
    a = @registers.a
    x = @registers.c
    @registers.a = a & x                     
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def anda_d(carry = 0)
    a = @registers.a
    x = @registers.d
    @registers.a = a & x                     
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def anda_e(carry = 0)
    a = @registers.a
    x = @registers.e
    @registers.a = a & x                     
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def anda_h(carry = 0)
    a = @registers.a
    x = @registers.h
    @registers.a = a & x                     
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def anda_l(carry = 0)
    a = @registers.a
    x = @registers.l
    @registers.a = a & x                     
    @registers.a = @registers.a & 255               # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 1
    @registers.t = 4                # 1 M taken
  end
  def anda_n(carry = 0)
    a = @registers.a
    x = @memory.rb[@registers.pc]
    @registers.pc = @registers.pc + 1
    @registers.a = a & x                           
    @registers.a = @registers.a & 255                   # Mask to 8-bits
    @registers.f = logic_flags(@registers.a)    # calculate flags
    @registers.m = 2
    @registers.t = 7                # 2 M taken
  end
  def anda_hl(carry = 0)
    a = @registers.a
    x = @memory.rb[((@registers.h << 8) & 0xF0) | ((@registers.l << 8) & 0x0F)]
    @registers.a = a & x                           # Perform addition
    @registers.a = @registers.a & 255                   # Mask to 8-bits
    @registers.f = add_flags(@registers.a)    # calculate flags
    @registers.m = 2
    @registers.t = 7                # 2 M taken
  end
  
end