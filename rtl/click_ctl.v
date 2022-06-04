`timescale 1ns / 1ps



module click_ctl(
    input wire [11:0] mouse_xpos, 
    input wire [11:0] mouse_ypos,
	input wire [10:0] hstart,
	input wire [10:0] vstart,
	input wire [10:0] hlength,
	input wire [10:0] vlength,
	input wire mouse_left,
	input wire rst,
    input wire pclk,
    
    output reg rect_clicked
    );
  
	reg rect_clicked_nxt;

	
	
always@*
	if ((mouse_xpos >= hstart) && (mouse_xpos <= hstart + hlength) && (mouse_ypos <= vstart + vlength) && (mouse_ypos <= vstart + vlength) && (mouse_left == 1)) begin
		rect_clicked_nxt = 1;
	end
	else begin
		rect_clicked_nxt = rect_clicked;
	end


always@(posedge pclk)
	if(rst) begin
		rect_clicked <= 0;
	end
	else begin
		rect_clicked <= rect_clicked_nxt;
	end

endmodule