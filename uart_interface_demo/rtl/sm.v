`timescale 1ns / 1ps

module sm (
input wire clk, rst,
input wire BUT1, BUT2, BUT3, 
input wire [7:0] rival_score, 
input wire start_sig,           //start indicator from 2nd device
input wire end_of_time,         //signal to go from GAME to SCORE

output reg [7:0] my_score,
output reg LED1,
output wire [1:0] state_out
);

localparam IDLE = 2'b00, WAIT = 2'b01, GAME = 2'b10, SCORE = 2'b11;

reg [2:0] state;
reg [7:0] my_score_nxt;
reg LED1_nxt;

always@* begin
    my_score_nxt = 0;
    if(state == SCORE)begin
        my_score_nxt = 8'b10101010;
        if(rival_score == 8'b00001111) LED1_nxt = 1'b1;
        else LED1_nxt = 1'b0;
    end
    else LED1_nxt = 1'b0; 
end

assign state_out = state;

always@(posedge clk) begin
    if(rst) begin
        state <= IDLE;
        my_score <= 0;
        LED1 <= 1'b0;
    end
    else begin
    my_score <= my_score_nxt;
    LED1 <= LED1_nxt;
    case(state)
        IDLE: state <= BUT1 ? WAIT:IDLE;
        WAIT: state <= start_sig ? GAME:WAIT;
        //GAME: state <= BUT2 ? SCORE:GAME;
        GAME: state <= end_of_time? SCORE:GAME;
        SCORE: state <= BUT3 ? IDLE:SCORE;
    endcase
    end
end
endmodule
