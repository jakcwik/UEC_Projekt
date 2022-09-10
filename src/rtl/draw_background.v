`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_background
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:  Template for simple module with registered outputs
 */
//////////////////////////////////////////////////////////////////////////////
module draw_background (
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [1:0] state,
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg [11:0] rgb_out,
  input wire pclk,
  input wire rst //add rst wire
  );
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg [11:0] rgb_nxt;
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@*
    if (vblnk_in || hblnk_in) rgb_nxt = 12'h0_0_0; 
    else
    begin
      // Active display, top edge, make a yellow line.
      if (vcount_in == 0) rgb_nxt = 12'hf_0_0;
      // Active display, bottom edge, make a red line.
      else if (vcount_in == 767) rgb_nxt = 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount_in == 0) rgb_nxt = 12'hf_0_0;
      // Active display, right edge, make a blue line.
      else if (hcount_in == 1023) rgb_nxt = 12'hf_0_0;
	  // Active display, inicjały
	  //Poziome części

	  else if (((vcount_in >= 334 && vcount_in <= 335) || (vcount_in >= 433 && vcount_in <= 434)) && (hcount_in >= 361 && hcount_in <= 660) && state==2'b00) rgb_nxt = 12'hc_6_1;
      //Pionowe części
	  else if ((vcount_in >= 334 && vcount_in <= 434) && ((hcount_in >= 360 && hcount_in <= 361) || (hcount_in >= 659 && hcount_in <= 660)) && state==2'b00) rgb_nxt = 12'hc_6_1;
	  // Active display, interior, fill with gray.
      // You will replace this with your own test.
      else rgb_nxt = 12'hd_a_f;    
    end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always @(posedge pclk)
	if(rst) begin
		hcount_out <= 0;
		hsync_out  <= 0;
		hblnk_out  <= 0;
		vcount_out <= 0;
		vsync_out  <= 0;
		vblnk_out  <= 0;
		rgb_out    <= 0;
	end
	else begin
		hcount_out <= hcount_in;
		hsync_out  <= hsync_in;
		hblnk_out  <= hblnk_in;
		vcount_out <= vcount_in;
		vsync_out  <= vsync_in;
		vblnk_out  <= vblnk_in;
		rgb_out    <= rgb_nxt;
	end



endmodule
