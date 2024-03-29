`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   uart_top
 Author:        Jan Pawlak
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:   This module has been created to gather all submodules used for UART connection between two devices.
				It passes state 

 */
//////////////////////////////////////////////////////////////////////////////

module uart_top(
    input wire clk,
    input wire rst,
    //uart
    input wire rx,
    //from game
    input wire [1:0] game_state,
    input wire [7:0] my_score,
    //uart
    output wire tx,
    //to game
    output wire start_game,           
    output wire [7:0] score_2nd_player
    );
    
    wire [7:0] w_data, r_data;
    wire rx_empty, tx_full, rd_uart, wr_uart;
    
    uart my_uart(
        //inputs
        .clk(clk),
        .reset(rst),
        .rd_uart(rd_uart),
        .wr_uart(wr_uart),
        .rx(rx),
        .w_data(w_data),
        //outputs
        .tx_full(tx_full), 
        .rx_empty(rx_empty), 
        .tx(tx),
        .r_data(r_data)
    );

    uart_interface my_uart_interface(
        //inputs
        .clk(clk),
        .rst(rst),
        .get_uart(r_data),
        .state_in(game_state),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .my_score(my_score),
        //outputs
        .send_uart(w_data),
        .rd_uart(rd_uart),
        .wr_uart(wr_uart),
        .start_game(start_game),
        .score_2nd_player(score_2nd_player)
    ); 

endmodule
