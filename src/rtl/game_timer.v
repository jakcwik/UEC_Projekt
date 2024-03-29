`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   game_timer
 Author:        Jan Pawlak
 Version:       1.0
 Last modified: 2022-08-20
 Coding style: safe, with FPGA sync reset
 Description:  This module has been created to measure time spent in GAME state.
			   Module acquires which state is game in. If player enters GAME state it starts to measure
			   time and after parametrized amout of time it sends signal to main module in order to enter SCORE state.
			   Exiting state GAME depends on this module. 
 */
//////////////////////////////////////////////////////////////////////////////
module game_timer(
    input wire clk, rst,  
	input wire[15:0] time_in,
	input wire clicked_duck,
    //from game
    input wire [1:0] state_in,      
    //to game
    output reg end_of_time
); 
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
localparam  GAME = 2'b10;  
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg end_of_time_nxt;
reg [16:0] T_counter, T_counter_nxt;       //2^16 = 131071 > 75k  
reg [9:0] ms_counter, ms_counter_nxt;      
reg [7:0] s_counter, s_counter_nxt;        //max 255
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@* begin
	if(rst) begin
		T_counter_nxt = 0;
        ms_counter_nxt = 0;
		s_counter_nxt = 0;
		end_of_time_nxt = 0'b0;
	end
    else if(state_in == GAME) begin        
		if(end_of_time == 1'b1) begin
			T_counter_nxt = 0;
			ms_counter_nxt = 0;
			s_counter_nxt = 0;
			end_of_time_nxt = 0'b0;
		end
        else if(T_counter == 75000) begin
            T_counter_nxt = 0;
            ms_counter_nxt = ms_counter + 1;
			s_counter_nxt = s_counter;
			end_of_time_nxt = 1'b0; 
        end
        else if(ms_counter == 1000) begin
			T_counter_nxt = T_counter;
            ms_counter_nxt = 0;
            s_counter_nxt = s_counter + 1;
			end_of_time_nxt = 1'b0; 
        end
        else if(s_counter == time_in) begin
			T_counter_nxt = 0;
			ms_counter_nxt = 0;
            s_counter_nxt = 0;
            end_of_time_nxt = 1'b1;
        end
        else if(clicked_duck == 1) begin
			T_counter_nxt = 0;
			ms_counter_nxt = 0;
            s_counter_nxt = 0;
            end_of_time_nxt = 1'b0;
        end
		else begin
			T_counter_nxt = T_counter + 1;
			ms_counter_nxt = ms_counter;
			s_counter_nxt = s_counter;
			end_of_time_nxt = end_of_time;
		end
    end
	else begin
		T_counter_nxt = 0;
        ms_counter_nxt = 0;
		s_counter_nxt = 0;
		end_of_time_nxt = 0;
	end
end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
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