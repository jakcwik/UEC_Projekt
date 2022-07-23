
module MouseCtl_buf (
  inout wire ps2_clk,
  inout wire ps2_data,
  input wire pclk,
  input wire mclk,
  input wire rst, 
  output reg mouse_left,
  output reg [11:0] xpos,
  output reg [11:0] ypos
  );
  
  wire [11:0] xpos_out_mouse, ypos_out_mouse;
  wire mouse_left_nxt;
  
  MouseCtl my_MouseCtl (
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.xpos(xpos_out_mouse),
	.ypos(ypos_out_mouse),
	.left(mouse_left_nxt),
	.clk(mclk)
  );
  
  
 always@(posedge pclk) begin
	if(rst) begin
		mouse_left <= 0;
		xpos <= 0;
		ypos <= 0;
	end
	else
		mouse_left <=  mouse_left_nxt;
		xpos <= xpos_out_mouse;
		ypos <= ypos_out_mouse;
 end
 endmodule