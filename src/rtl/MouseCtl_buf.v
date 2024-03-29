//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   MouseCtl_buf
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2020-08-20
 Coding style: safe, with FPGA sync reset
 Description:  This module synchronizes two clocks in order to proper mouse behaviour.
 */
//////////////////////////////////////////////////////////////////////////////
module MouseCtl_buf (
  inout wire ps2_clk,
  inout wire ps2_data,
  input wire pclk,
  input wire mclk,
  input wire rst, 
  output reg mouse_left,
  output reg mouse_right,
  output reg [11:0] xpos,
  output reg [11:0] ypos
  );
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
  wire [11:0] xpos_out_mouse, ypos_out_mouse;
  wire mouse_left_nxt, mouse_right_nxt;
//------------------------------------------------------------------------------
// MouseCtl module
//------------------------------------------------------------------------------
  MouseCtl my_MouseCtl (
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.xpos(xpos_out_mouse),
	.ypos(ypos_out_mouse),
	.left(mouse_left_nxt),
	.right(mouse_right_nxt),
	.clk(mclk)
  );
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
 always@(posedge pclk) begin
	if(rst) begin
		mouse_left <= 0;
		xpos <= 0;
		ypos <= 0;
	end
	else
		mouse_left <=  mouse_left_nxt;
		mouse_right <= mouse_right_nxt;
		xpos <= xpos_out_mouse;
		ypos <= ypos_out_mouse;
 end
 endmodule