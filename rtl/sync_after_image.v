
`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module sync_after_image (
  //inputs
  input wire vs_in,
  input wire hs_in,
  input wire hblnk_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire [10:0] vcount_in,

  //outputs
  output reg hblnk,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg [10:0] vcount,
  output reg vs_out,
  output reg hs_out,
  //clock and reset
  input wire pclk,
  input wire rst
  );
  
  

always @(posedge pclk)
	if(rst) begin
		vs_out  <=0;
		hs_out  <=0;
		hblnk		<=0;
		vblnk		<=0;
		hcount		<=0;
		vcount		<=0;	
	end
	else begin
		vs_out	<=vs_in;
		hs_out  <=hs_in;
		hblnk		<=hblnk_in;
		vblnk		<=vblnk_in;
		hcount		<=hcount_in;
		vcount		<=vcount_in;
	end
endmodule