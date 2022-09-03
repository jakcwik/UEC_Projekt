
module score_counter(
    input wire clk, rst,  
	input wire clicked_duck,    

    output reg[6:0] score
); 
      
reg [6:0] score_nxt;        //max 127

always@(posedge clicked_duck or posedge rst) begin
	if(rst)
		score_nxt = 0;
	else
		score_nxt = score + 1;
end


always@(posedge clk) begin
    if(rst) begin
		score <= 0;
    end
    else begin
		score <= score_nxt;
    end
end
endmodule