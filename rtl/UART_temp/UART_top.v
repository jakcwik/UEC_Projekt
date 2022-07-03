`timescale 1ns / 1ps

module UART_top(
    input wire clk,
    input wire reset,
    //input wire read_uart_but,
    input wire rx,
    output wire tx,
    output wire [3:0] an,
    output wire [7:0] sseg,
    output wire led0 //temp
    /*
    buttony
    input wire loopback_enable,
    output reg tx,
    output reg rx_monitor,
    output reg tx_monitor*/
    );
    
    wire [7:0] data_in;
    wire rx_empty, rd_uart;
    
    uart my_uart(
        //inputs
        .clk(clk),
        .reset(reset),
        .rd_uart(rd_uart),
        .wr_uart(),
        .rx(rx),
        .w_data(),
        //outputs
        .tx_full(), 
        .rx_empty(rx_empty), 
        .tx(tx),
        .r_data(data_in)
    );
    
    wire [7:0] hex_out_curr, hex_out_prev;
    
    data_in my_data_in(
        //inputs
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .rx_empty(rx_empty),
        //outputs
        .rd_uart(rd_uart),
        .hex_out_curr(hex_out_curr),
        .hex_out_prev(hex_out_prev),
        .led0(led0)
    );
    
    disp_hex_mux my_disp_hex_mux(
        //inputs
        .clk(clk), 
        .reset(reset),
        .hex3(hex_out_prev[7:4]), 
        .hex2(hex_out_prev[3:0]), 
        .hex1(hex_out_curr[7:4]), 
        .hex0(hex_out_curr[3:0]), 
        .dp_in(4'b1111),
         //outputs
        .an(an),
        .sseg(sseg) 
    );
    
  
endmodule
