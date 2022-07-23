//plik roboczy
//trzeba ustawić aby sygnał clicked_duck był jednostkowy

module score_counter(
    input wire pclk, rst,  
	input wire clicked_duck,    

    output reg score
); 
     
reg [7:0] s_counter, s_counter_nxt;        //max 255

always@* begin
	if(rst) begin
		s_counter_nxt = 0;
	end
	else begin
		if(clicked_duck == 1) begin
			s_counter_nxt = score + 1;
		end
		else begin
			s_counter_nxt = score;
		end
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