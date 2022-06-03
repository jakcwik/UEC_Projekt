// File: draw_background.v


// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_background (
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
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

//Next state registers
reg [11:0] rgb_nxt;

always@*
    if (vblnk_in || hblnk_in) rgb_nxt = 12'h0_0_0; 
    else
    begin
      // Active display, top edge, make a yellow line.
      if (vcount_in == 0) rgb_nxt = 12'hf_f_0;
      // Active display, bottom edge, make a red line.
      else if (vcount_in == 599) rgb_nxt = 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount_in == 0) rgb_nxt = 12'h0_f_0;
      // Active display, right edge, make a blue line.
      else if (hcount_in == 799) rgb_nxt = 12'h0_0_f;
	  // Active display, inicjały
	  //Poziome części
	  else if (((vcount_in >= 149 && vcount_in <= 150) || (vcount_in >= 248 && vcount_in <= 249) || (vcount_in >= 350 && vcount_in <= 351) || (vcount_in >= 448 && vcount_in <= 449)) && (hcount_in >= 249 && hcount_in <= 549)) rgb_nxt = 12'hc_6_1; 
      //Pionowe części
	  else if (((vcount_in >= 149 && vcount_in <= 249) || (vcount_in >= 349 && vcount_in <= 449)) && ((hcount_in >= 249 && hcount_in <= 250) || (hcount_in >= 548 && hcount_in <= 549))) rgb_nxt = 12'hc_6_1;
	  // Active display, interior, fill with gray.
      // You will replace this with your own test.
      else rgb_nxt = 12'h8_8_8;    
    end
  
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
