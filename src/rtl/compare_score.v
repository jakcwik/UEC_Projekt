//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   compare_score
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2020-08-20
 Coding style: safe, with FPGA sync reset
 Description:  This module compares my score with rival's.
 */
//////////////////////////////////////////////////////////////////////////////
module compare_score(
    input wire clk, rst,  
	input wire[6:0] my_score,
	input wire[7:0] op_score,    

    output reg[6:0] winner
); 
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------     
reg [6:0] winner_nxt;        //max 127
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@* begin
	if(my_score > op_score[6:0])
		winner_nxt = 7'h31;
	else
		winner_nxt = 7'h32;
end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always@(posedge clk) begin
    if(rst) begin
		winner <= 7'h30;
    end
    else begin
		winner <= winner_nxt;
    end
end
endmodule