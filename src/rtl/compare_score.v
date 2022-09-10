//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   compare_score
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:  Template for simple module with registered outputs
 */
//////////////////////////////////////////////////////////////////////////////
module compare_score(
    input wire clk, rst,  
	input wire[6:0] my_score, op_score,    

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
	if(my_score > op_score)
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