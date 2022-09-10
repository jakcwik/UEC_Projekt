//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   score2ascii_converter
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2022-??-??
 Coding style: safe, with FPGA sync reset
 Description:  Score converter to ascii code
 */
//////////////////////////////////////////////////////////////////////////////
module score2ascii_converter(
    input wire clk, rst,  
	input wire[6:0] score,

    output reg[6:0] ascii_1,
	output reg[6:0] ascii_0
); 
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg[6:0] ascii_0_nxt, ascii_1_nxt;
reg[3:0] score_0_nxt, score_0;
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@* begin
	if(rst) begin
		ascii_1_nxt = 0;
		score_0_nxt = 0;
	end
	else if(score < 10) begin
		ascii_1_nxt = 7'h30;
		score_0_nxt = score;
	end
    else if(score < 20) begin        
		ascii_1_nxt = 7'h31;
		score_0_nxt = score - 10;
    end
	else if(score < 30) begin
		ascii_1_nxt = 7'h32;
		score_0_nxt = score - 20;
	end
    else if(score < 40) begin        
		ascii_1_nxt = 7'h33;
		score_0_nxt = score - 30;
    end
	else if(score < 50) begin
		ascii_1_nxt = 7'h34;
		score_0_nxt = score - 40;
	end
    else if(score < 60) begin        
		ascii_1_nxt = 7'h35;
		score_0_nxt = score - 50;
    end
	else if(score < 70) begin
		ascii_1_nxt = 7'h36;
		score_0_nxt = score - 60;
	end
    else if(score < 80) begin        
		ascii_1_nxt = 7'h37;
		score_0_nxt = score - 70;
    end
	else if(score < 90) begin
		ascii_1_nxt = 7'h38;
		score_0_nxt = score - 80;
	end
    else if(score < 100) begin        
		ascii_1_nxt = 7'h39;
		score_0_nxt = score - 90;
    end
	else begin
		ascii_1_nxt = 0;
		score_0_nxt = 0;
	end
end

always@* begin
	if(rst) begin
		ascii_0_nxt = 7'h30;
	end
	else
		case(score_0)
		0: ascii_0_nxt = 7'h30;
		1: ascii_0_nxt = 7'h31;
		2: ascii_0_nxt = 7'h32;
		3: ascii_0_nxt = 7'h33;
		4: ascii_0_nxt = 7'h34;
		5: ascii_0_nxt = 7'h35;
		6: ascii_0_nxt = 7'h36;
		7: ascii_0_nxt = 7'h37;
		8: ascii_0_nxt = 7'h38;
		9: ascii_0_nxt = 7'h39;
		default: ascii_0_nxt = 7'h30;
		endcase
end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always@(posedge clk) begin
    if(rst) begin
		ascii_1 <= 0;
		ascii_0 <= 0;
		score_0 <= 0;
    end
    else begin
		ascii_1 <= ascii_1_nxt;
		ascii_0 <= ascii_0_nxt;
		score_0 <= score_0_nxt;
    end
end
endmodule