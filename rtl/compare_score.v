module compare_score(
    input wire clk, rst,  
	input wire[6:0] my_score, op_score,    

    output reg[6:0] winner
); 
      
reg [6:0] winner_nxt;        //max 127

always@* begin
	if(my_score > op_score)
		winner_nxt = 7'h31;
	else
		winner_nxt = 7'h32;
end


always@(posedge clk) begin
    if(rst) begin
		winner <= 7'h30;
    end
    else begin
		winner <= winner_nxt;
    end
end
endmodule