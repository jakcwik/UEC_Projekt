`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   uart_interface
 Author:        Jan Pawlak
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:   This module has been created to control communication between two devices through UART.
				Module informs the rival's device if we are in WAIT state and acquires information
				from rival's device about its state. 
				Given that our device is in WAIT state if rival's device enters or already is in WAIT 
				state our device enters GAME state. 

				Note: WAIT_STATE_SIGNAL and my score are being CONTINUOSLY send through UART (when called).
				WAIT_STATE_SIGNAL value has been chosen arbitraly.
 */
//////////////////////////////////////////////////////////////////////////////


module uart_interface(
    input wire clk, rst,
    //from uart
    input wire [7:0] get_uart,      
    input wire tx_full, rx_empty,   
    //from game
    input wire [1:0] state_in,      
    input wire [7:0] my_score,      
    //to uart
    output reg [7:0] send_uart, 
    output reg rd_uart, wr_uart,
    //to game
    output reg start_game,           
    output reg [7:0] score_2nd_player
); 
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
localparam WAIT_STATE_SIGNAL = 8'hFF, WAIT = 2'b01, SCORE = 2'b11 ;
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg [7:0] send_uart_nxt, score_2nd_player_nxt;
reg rd_uart_nxt, wr_uart_nxt, start_game_nxt;
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@* begin
    send_uart_nxt = 0;
    wr_uart_nxt = 1'b0;
    start_game_nxt = 1'b0;
    rd_uart_nxt = 1'b0;
    score_2nd_player_nxt = score_2nd_player;
    case(state_in)
        WAIT: begin
            if(!tx_full ) begin                              
                send_uart_nxt = WAIT_STATE_SIGNAL;                  //inform 2nd device about WAIT state
                wr_uart_nxt = 1'b1;
            end
            if(!rx_empty && get_uart == WAIT_STATE_SIGNAL) begin    //check if 2nd device is in WAIT state
                start_game_nxt = 1'b1;                              //if so, infrom this device to enter GAME state
                rd_uart_nxt = 1'b1;                                 
            end
         end
        SCORE: begin                                        
            if(!tx_full) begin 
                send_uart_nxt = my_score;                           //send score to 2nd device
                wr_uart_nxt = 1'b1;
            end
            if(!rx_empty) begin 
                score_2nd_player_nxt = get_uart;                    //get score from 2nd device
                rd_uart_nxt = 1'b1;
            end
        end
    endcase
end    
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always@(posedge clk) begin
    if(rst) begin
        send_uart <= 0;
        rd_uart <= 0;
        wr_uart <= 0;
        start_game <= 0;
        score_2nd_player <= 0;
    end
    else begin
        send_uart <= send_uart_nxt;
        rd_uart <= rd_uart_nxt;
        wr_uart <= wr_uart_nxt;
        start_game <= start_game_nxt;
        score_2nd_player <= score_2nd_player_nxt; 
    end
end
endmodule