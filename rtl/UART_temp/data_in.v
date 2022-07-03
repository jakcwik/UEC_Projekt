`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module data_in(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire rx_empty,
    output reg rd_uart,
    output wire [7:0] hex_out_curr,
    output wire [7:0] hex_out_prev,
    output wire led0
    );
    
    reg rd_uart_nxt;
    reg [7:0] data_curr, data_curr_nxt;
    reg [7:0] data_prev, data_prev_nxt;
    
    always@*
    begin
        
        if(~rx_empty)   //not empty
        begin
            data_curr_nxt = data_in;
            data_prev_nxt = data_curr;
            rd_uart_nxt = 1'b1;
        end
        else 
        begin
            data_curr_nxt = data_curr;
            data_prev_nxt = data_prev;
            rd_uart_nxt = 1'b0;
        end    
    end
    
    always@(posedge clk or posedge reset) 
    begin
        if(reset)
        begin
            data_curr <= 0;
            data_prev <= 0;
            rd_uart <= 0;
        end
        else
        begin
            data_curr <= data_curr_nxt;
            data_prev <= data_prev_nxt;
            rd_uart <= rd_uart_nxt;
        end
        //$display("data_curr=%d", data_in);
    end
    
    assign hex_out_curr = data_curr;
    assign hex_out_prev = data_prev;
    assign led0 = rx_empty; 
    
endmodule
