`timescale 1ns / 1ps

module UART_top(
    input wire clk,
    input wire rst,
    //input wire read_uart_but,
    input wire rx,
    output wire tx,
    
    input wire BUT1, BUT2, BUT3,
    
    output wire LED1 //temp
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

    wire [7:0] my_score, score_2nd_player;
    wire [1:0] state_out;
    wire start_game;
    
    uart_interface my_uart_interface(
        //inputs
        .clk(clk),
        .rst(rst),
        .get_uart(r_data),
        .state_in(state_out),
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
        
    wire end_of_time;
        
    sm my_sm(
        //inputs
        .clk(clk), 
        .rst(rst),
        .BUT1(BUT1), 
        .BUT2(BUT2), 
        .BUT3(BUT3),
        .rival_score(score_2nd_player), 
        .start_sig(start_game),
        .end_of_time(end_of_time),
        //outputs
        .my_score(my_score),
        .LED1(LED1),
        .state_out(state_out)
    );
    
    game_timer my_game_timer(
    //inputs
    .clk(clk),
    .rst(rst),  
    .state_in(state_out),      
    //outputs
    .end_of_time(end_of_time)
    ); 

endmodule
