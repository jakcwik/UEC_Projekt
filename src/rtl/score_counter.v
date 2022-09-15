//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   score_counter
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2020-08-20
 Coding style: safe, with FPGA sync reset
 Description:  This module counts score. It increments every time the duck is clicked.
 */
//////////////////////////////////////////////////////////////////////////////
module score_counter(
    input wire clk, rst,
	input wire clicked_duck,    
	input wire mouse_right,
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