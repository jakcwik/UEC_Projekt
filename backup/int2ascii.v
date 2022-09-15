//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   int2ascii
 Author:        Jan Pawlak
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: Xilinx recommended + ANSI ports
 Description:  This module has been created to convert score from integer value to ascii code. 
			   It acquires decimal value. As an output it returns two digits (LSD, MSD) in ascii.  
			   NOTE: Two digit score assumed
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module int2ascii(
    input wire /*clk*/, rst,
    //from game
    input wire [7:0] score,         
    //to char_rom_score             
    output wire [3:0] lsd_ascii,
    output wire [3:0] msd_ascii
);

reg [3:0] score_lsd, score_msd, score_lsd_nxt, score_msd_nxt ;

always@* begin
    if(rst) begin
        score_lsd_nxt = 0;
        score_msd_nxt = 0;
    end
    else begin
    score_lsd_nxt = score % 10;
    score_msd_nxt = score / 10;
    end
end

always@(posedge clk)
    if(rst) begin
        score_lsd <= 0;
        score_msd <= 0;
    end
    else begin
        score_lsd <= score_lsd_nxt;
        score_msd <= score_msd_nxt; 
    end
    
assign lsd_ascii = 30 + score_lsd;
assign msd_ascii = 30 + score_msd;

endmodule