// File: testbench.v
// This is a top level testbench for the
// vga_example design, which is part of
// the EE178 Lab #4 assignment.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

module draw_rect_ctl_tb(
  output reg [11:0] xpos,
  output reg [11:0] ypos,
  output reg mouse_left,
  output reg clk,
  output reg rst
  );
  
  
  
  initial begin
  mouse_left <=0;
  rst <= 0;
  xpos <= 0;
  ypos <=0;
  #5 rst <= 1;
  #800 rst <= 0;
  #1000 mouse_left <=1;
  #2000 mouse_left <=0;
 
  
  end
  
  // Describe a process that generates a clock
  // signal. The clock is 100 MHz.

  always
  begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end
  
  
 endmodule