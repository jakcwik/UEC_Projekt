//plik roboczy


module click_ctl(
	input wire [11:0] rgb_in,
	input wire mouse_left,
	input wire rst,
    input wire pclk,
    
    output reg rect_clicked
    );
  
	reg rect_clicked_nxt;

localparam BG_COLOR = 12'h888, BLNK_COLOR = 12'h000, BORDER_COLOR = 12'h00f;	
	
always@*
	if ((rgb_in != (BG_COLOR || BLNK_COLOR || BORDER_COLOR)) && (mouse_left == 1)) begin
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