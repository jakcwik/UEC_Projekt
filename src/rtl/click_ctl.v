`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   click_ctl
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2020-08-20
 Coding style: safe, with FPGA sync reset
 Description:  This module informs if mouse click occured.
 */
//////////////////////////////////////////////////////////////////////////////
module click_ctl(
    input wire [11:0] mouse_xpos, 
    input wire [11:0] mouse_ypos,
	input wire [10:0] hstart,
	input wire [10:0] vstart,
	input wire [10:0] hlength,
	input wire [10:0] vlength,
	input wire [1:0] state_in,
	input wire mouse_left,
	input wire rst,
    input wire pclk,
    
    output reg rect_clicked
    );
 //------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
	reg rect_clicked_nxt;
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@* begin
	if (state_in == 2'b10) begin
		rect_clicked_nxt = 0;
	end
	else if ((mouse_xpos >= hstart) && (mouse_xpos <= hstart + hlength) && (mouse_ypos <= vstart + vlength) && (mouse_ypos <= vstart + vlength) && (mouse_left == 1)) begin
		rect_clicked_nxt = 1;
	end
	else begin
		rect_clicked_nxt = rect_clicked;
	end
end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always@(posedge pclk)
	if(rst) begin
		rect_clicked <= 0;
	end
	else begin
		rect_clicked <= rect_clicked_nxt;
	end

endmodule