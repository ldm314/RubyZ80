require 'cpu.rb'

describe Z80cpu, "#arithmatic" do
  it "should add registers to a" do
    cpu = Z80cpu.new
    cpu.registers.a = 5
    cpu.adda_a
    
    cpu.registers.a.should == 10
    cpu.registers.f.should == 0
    cpu.registers.m.should == 1
    cpu.registers.t.should == 4
    
  end

  it "should set overflow on addr_x" do
    cpu = Z80cpu.new
    cpu.registers.a = 65
    cpu.adda_a
    
    cpu.registers.a.should == 130 #overflow 8 bit signed
    (cpu.registers.f & Z80cpu::OVER).should_not == 0
    cpu.registers.m.should == 1
    cpu.registers.t.should == 4
    
  end

  it "should set carry on addr_x" do
    cpu = Z80cpu.new
    cpu.registers.a = 255
    cpu.adda_a
    
    cpu.registers.a.should == 254 # 255 + 255 shifts all bits left one, should carry 
    (cpu.registers.f & Z80cpu::CARRY).should_not == 0
    cpu.registers.m.should == 1
    cpu.registers.t.should == 4
    
  end


end