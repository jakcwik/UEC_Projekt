//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   ran_num_gen
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:  Template for simple module with registered outputs
 */
//////////////////////////////////////////////////////////////////////////////
//960x704
module ran_num_gen(
    input             clk,
    input             rst,
	input             clicked_duck,
	input [1:0]		  state,
    output reg [9:0] hor_data,
	output reg [9:0] ver_data
    );
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
	localparam DUCK_TIME = 1;
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
	reg [9:0] hor_data_next;
	reg [8:0] ver_data_next;
	wire game_timer;
//------------------------------------------------------------------------------
// TIMER
//------------------------------------------------------------------------------    
  game_timer my_game_timer2(
  .clk(clk),
  .rst(rst),
  .time_in(DUCK_TIME),
  .state_in(state),
  .clicked_duck(clicked_duck),
  .end_of_time(game_timer)
  );
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
   always@* begin
      hor_data_next = hor_data;
      repeat(10) begin
         hor_data_next = {(hor_data_next[9]^hor_data_next[1]), hor_data_next[9:1]};
      end
   end
   
   always@* begin
      ver_data_next = ver_data;
      repeat(9) begin
         ver_data_next = {(ver_data_next[8]^ver_data_next[1]), ver_data_next[8:1]};
      end
   end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
   always@(posedge clk) begin
      if(rst)
         hor_data <= 10'b0001111111; //1111...
	  else if(hor_data_next>960 && (game_timer == 1 || clicked_duck == 1))
		 hor_data <= 450;
      else if(game_timer == 1 || clicked_duck == 1)
         hor_data <= hor_data_next;
	  else
	     hor_data <= hor_data;
   end

   always@(posedge clk) begin
      if(rst)
         ver_data <= 10'b0001111111; //01111...
      else if(game_timer == 1 || clicked_duck == 1)
         ver_data <= ver_data_next + 96;
	  else
	     ver_data <= ver_data;
   end

endmodule