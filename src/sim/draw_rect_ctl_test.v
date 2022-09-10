																// File: testbench.v
// This is a top level testbench for the
// vga_example design, which is part of
// the EE178 Lab #4 assignment.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

module draw_rect_ctl_test;

  // Declare wires to be driven by the outputs
  // of the design, and regs to drive the inputs.
  // The testbench will be in control of inputs
  // to the design, and will check the outputs.
  // Then, instantiate the design to be tested.

  wire rst;      //change
  wire clk;
  //wire pclk_mirror;
  //wire vs, hs;
  //wire [3:0] r, g, b;
  wire [11:0] xpos, ypos;
  wire [11:0] xpos_out, ypos_out;
  wire mouse_left;
  
  

  

  
  draw_rect_ctl my_draw_rect_ctl (
  //inputs
    .pclk(clk),
    .rst(rst),
    .mouse_xpos(xpos),
    .mouse_ypos(ypos),
    .mouse_left(mouse_left),
	//outputs
    .xpos(xpos_out),
    .ypos(ypos_out)     
  );


  draw_rect_ctl_tb my_draw_rect_ctl_tb (
    .mouse_left(mouse_left),
    .xpos(xpos), 
    .ypos(ypos),
	.clk(clk),
	.rst(rst)
  );
  



  // Assign values to the input signals and
  // check the output results. This template
  // is meant to get you started, you can modify
  // it as you see fit. If you simply run it as
  // provided, you will need to visually inspect
  // the output waveforms to see if they make
  // sense...

  initial
  begin
    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");
    wait (mouse_left == 1'b0);
    @(negedge mouse_left) $display("Info: negedge VS at %t",$time);
    @(negedge mouse_left) $display("Info: negedge VS at %t",$time);
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $stop;
  end

endmodule