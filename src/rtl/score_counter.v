//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   score_counter
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:  Template for simple module with registered outputs
 */
//////////////////////////////////////////////////////////////////////////////
module score_counter(
    input wire clk, rst,  
	input wire clicked_duck,    

    output reg[6:0] score
); 
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg [6:0] score_nxt;        //max 127
//------------------------------------------------------------------------------
// logic with async reset
//------------------------------------------------------------------------------
always@(posedge clicked_duck or posedge rst) begin
	if(rst)
		score_nxt = 0;
	else
		score_nxt = score + 1;
end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always@(posedge clk) begin
    if(rst) begin
		score <= 0;
    end
    else begin
		score <= score_nxt;
    end
end
endmodule