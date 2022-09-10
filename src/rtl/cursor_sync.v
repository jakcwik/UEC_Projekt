`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module cursor_sync (
  //inputs
  input wire [11:0] xpos,
  input wire [11:0] ypos,
  input wire left,
  //outputs
  output reg [11:0] xpos_out,
  output reg [11:0] ypos_out,
  output reg left_out,
  //clock and reset
  input wire pclk,
  input wire rst
  );
  
  
//next state registers and wires
reg vs_d, hs_d;






always @(posedge pclk)
	if(rst) begin
		xpos_out  <=0;
		ypos_out  <=0;
		left_out  <=0;
	end
	else begin
		xpos_out	<=xpos;
		ypos_out    <=ypos;
		left_out    <=left;

	end
endmodule