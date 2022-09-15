//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   click_image_ctl
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2020-08-20
 Coding style: safe, with FPGA sync reset
 Description:  This module informs if mouse click on the duck occured.
 */
//////////////////////////////////////////////////////////////////////////////
module click_image_ctl(
    input wire [10:0] vcount_in,
    input wire [10:0] hcount_in,
	input wire [11:0] xpos_mouse,
	input wire [11:0] ypos_mouse,
	input wire [11:0] rgb_in,
	input wire mouse_left,
	input wire rst,
    input wire pclk,
    
    output reg rect_clicked
    );
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
	localparam BG_COLOR = 12'hdaf, BLNK_COLOR = 12'h000, BORDER_COLOR = 12'hf00;	
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
	reg rect_clicked_nxt, latch_end, latch_end_nxt;
	reg[11:0] xpos, ypos, xpos_nxt, ypos_nxt;
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@* begin
	if(mouse_left == 0) begin
		xpos_nxt = xpos_mouse;
		ypos_nxt = ypos_mouse;
		latch_end_nxt = 0;
	end
	else if(latch_end == 1) begin
		xpos_nxt = xpos;
		ypos_nxt = ypos;
		latch_end_nxt = 1;
	end
	else begin
		xpos_nxt = xpos_mouse;
		ypos_nxt = ypos_mouse;
		latch_end_nxt = 1;
	end
end

always@* begin
	if(mouse_left == 0) begin
		rect_clicked_nxt = 0;
	end
	else if ((rgb_in != BG_COLOR) && (rgb_in != BLNK_COLOR) && (rgb_in != BORDER_COLOR) && (xpos == hcount_in) && (ypos == vcount_in)) begin
		rect_clicked_nxt = 1;
	end
	else begin
		rect_clicked_nxt = rect_clicked;
	end
end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always@(posedge pclk) begin
	if(rst) begin
		latch_end <= 0;
		xpos <= 0;
		ypos <= 0;
	end
	else begin
		latch_end <= latch_end_nxt;
		xpos <= xpos_nxt;
		ypos <= ypos_nxt;
	end
end

always@(posedge pclk) begin
	if(rst) begin
		rect_clicked <= 0;
	end
	else begin
		rect_clicked <= rect_clicked_nxt;
	end
end
endmodule