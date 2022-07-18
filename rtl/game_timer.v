//This module has been created to measure time spent in GAME state.
//Module acquires which state is game in. If player enters GAME state it starts to measure
//time and after parametrized amout of time it sends signal to main module in order to enter 
//SCORE state.
//Exiting GAME state depends on this module. 

//100MHz CLK ASSUMED; T=10ns

`timescale 1ns / 1ps

module game_timer(
    input wire clk, rst,  
	input wire time_in,
    //from game
    input wire [1:0] state_in,      
    //to game
    output reg end_of_time
); 

localparam  GAME = 2'b10;  

reg end_of_time_nxt;
reg [16:0] T_counter, T_counter_nxt;       //2^16 = 131071 > 100k
reg [9:0] ms_counter, ms_counter_nxt;      
reg [7:0] s_counter, s_counter_nxt;        //max 255

always@* begin
	if(rst) begin
		T_counter_nxt = 0;
        ms_counter_nxt = 0;
		s_counter_nxt = 0;
		end_of_time_nxt = 0;
	end
    else if(state_in == GAME) begin        
    T_counter_nxt = T_counter + 1;
		if(end_of_time == 1'b1) begin
			end_of_time_nxt = 1'b0;
		end
        else if(T_counter == 100000) begin
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
    end
	else begin
		T_counter_nxt = 0;
        ms_counter_nxt = 0;
		s_counter_nxt = 0;
		end_of_time_nxt = 0;
	end
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