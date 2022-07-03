`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2022 14:05:01
// Design Name: 
// Module Name: UART_monitor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_monitor(
    input wire clk,
    input wire rx,
    input wire loopback_enable,
    output reg tx,
    output reg rx_monitor,
    output reg tx_monitor
    );
    
    always@*
    begin
        if(loopback_enable) tx = rx;
        else tx = 0;
    end
    
    always@(posedge clk) 
    begin
        rx_monitor <= rx;
        tx_monitor <= tx;
    end
    
endmodule
