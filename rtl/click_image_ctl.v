//plik roboczy


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
  
	reg rect_clicked_nxt, latch_end, latch_end_nxt;
	reg[10:0] xpos, ypos, xpos_nxt, ypos_nxt;

localparam BG_COLOR = 12'h888, BLNK_COLOR = 12'h000, BORDER_COLOR = 12'h00f;	

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
	else if ((rgb_in != (BG_COLOR || BLNK_COLOR || BORDER_COLOR)) && (xpos == hcount_in) && (ypos == vcount_in)) begin
		rect_clicked_nxt = 1;
	end
	else begin
		rect_clicked_nxt = rect_clicked;
	end
end

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