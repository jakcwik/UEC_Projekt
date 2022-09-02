//plik roboczy
//trzeba ustawić aby sygnał clicked_duck był jednostkowy

module score_counter(
    input wire clk, rst,  
	input wire clicked_duck,    

    output reg[7:0] score
); 
      
reg [7:0] s_counter_nxt;        //max 255

always@(posedge clicked_duck or posedge rst) begin
	if(rst)
		s_counter_nxt = 0;
	else
		s_counter_nxt = score + 1;
end


always@(posedge clk) begin
    if(rst) begin
		score <= 0;
    end
    else begin
		score <= s_counter_nxt;
    end
end
endmodule