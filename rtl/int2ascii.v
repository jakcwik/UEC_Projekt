//This module has been created to convert score from integer value to ascii code. 
//It acquires decimal value, as an output it returns two digits (LSD, MSD) in ascii.  

//NOTE: Two digit score assumed

`timescale 1ns / 1ps

module int2ascii(
    input wire clk, rst,
    //from game
    input wire [7:0] score,         //???
    //to game
    output wire [3:0] lsd_ascii,     //
    output wire [3:0] msd_ascii
);

localparam score_lsd, score_msd;


assign lsd_ascii = 30 + score_lsd;
assign lsd_ascii = 30 + score_lsd;

always@* begin
    score_lsd = score % 10;
    score_msd = score / 10;
end

always@(posedge clk) begin
    if(rst) begin
        end_of_time <= 1'b0;
        T_counter <= 0;
        ms_counter <= 0;
        s_counter <= 0;
    end
    else begin
        end_of_time <= end_of_time_nxt;
        T_counter <= T_counter_nxt;
        ms_counter <= ms_counter_nxt;
        s_counter <= s_counter_nxt;
    end
end
endmodule