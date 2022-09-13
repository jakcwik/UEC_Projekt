//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   state_machine
 Author:        Jakub Ćwik/Jan Pawlak
 Version:       1.0
 Last modified: 2022-??-??
 Coding style: safe with FPGA sync reset
 Description:  State machine for UEC2 project
 */
//////////////////////////////////////////////////////////////////////////////
module state_machine (
input wire pclk,
input wire rect_clicked_play,
input wire rst_d,
input wire uart_start,
input wire mouse_clicked_stop,
input wire [11:0] rgb_out_rc_play,
input wire [11:0] rgb_out_rc_wait,
input wire [11:0] rgb_out_dr_game,
input wire [11:0] rgb_out_rc_score,
output reg [11:0] idle_height_play,
output reg [10:0] vstart_click_play,
output reg [11:0] idle_width_play,
output reg [10:0] hstart_click_play,
output reg [10:0] hlength_click_play,
output reg [10:0] vlength_click_play,
output reg [11:0] rgb_out_rc,
output reg [1:0] state
);
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
parameter IDLE = 2'b00, WAIT = 2'b01, GAME = 2'b10, SCORE = 2'b11, GAME_TIME = 15;
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg[1:0] state_nxt;
reg[11:0]  rgb_out_rc_nxt;
reg[11:0]  idle_height_play_nxt, idle_width_play_nxt;
reg[10:0]  hstart_click_play_nxt, vstart_click_play_nxt, hlength_click_play_nxt, vlength_click_play_nxt;
wire game_timer;
//------------------------------------------------------------------------------
// timer module
//------------------------------------------------------------------------------
  game_timer my_game_timer(
  .clk(pclk),
  .rst(rst_d),
  .time_in(GAME_TIME),
  .state_in(state),
  .end_of_time(game_timer),
  .clicked_duck(1'b0)
  );
//------------------------------------------------------------------------------
// next state logic
//------------------------------------------------------------------------------
always@* begin
	if (rst_d) begin
					state_nxt 			   = IDLE;
					idle_height_play_nxt   = 376;
					vstart_click_play_nxt  = 376;				
					idle_width_play_nxt    = 492;
					hstart_click_play_nxt  = 492;
					hlength_click_play_nxt = 300;
					vlength_click_play_nxt = 100;
					rgb_out_rc_nxt = rgb_out_rc_play;
	end
	else
		case (state)
			IDLE:
				if (rect_clicked_play == 1) begin
					state_nxt 			   = GAME;
					idle_height_play_nxt   = 0;
					vstart_click_play_nxt  = 0;
					idle_width_play_nxt    = 0;
					hstart_click_play_nxt  = 0;
					hlength_click_play_nxt = 0;
					vlength_click_play_nxt = 0;
					rgb_out_rc_nxt		   = rgb_out_rc_wait;
				end
				else begin
					state_nxt 			   = IDLE;
					idle_height_play_nxt   = 376;
					vstart_click_play_nxt  = 376;				
					idle_width_play_nxt    = 492;
					hstart_click_play_nxt  = 492;
					hlength_click_play_nxt = 300;
					vlength_click_play_nxt = 100;
					rgb_out_rc_nxt = rgb_out_rc_play;
				end
			WAIT:
				if (rect_clicked_play & uart_start) begin
					state_nxt 			   = GAME;
					idle_height_play_nxt   = 0;
					vstart_click_play_nxt  = 0;				
					idle_width_play_nxt    = 0;
					hstart_click_play_nxt  = 0;
					hlength_click_play_nxt = 0;
					vlength_click_play_nxt = 0;
					rgb_out_rc_nxt 		   = rgb_out_rc_wait;
				end
				else begin
					state_nxt 			   = WAIT;
					rgb_out_rc_nxt 		   = rgb_out_rc_wait;
					idle_height_play_nxt   = 376;
					vstart_click_play_nxt  = 0;
					idle_width_play_nxt    = 492;
					hstart_click_play_nxt  = 0;
					hlength_click_play_nxt = 0;
					vlength_click_play_nxt = 0;
				end
			GAME:
				if (game_timer == 0) begin
					state_nxt 			   = GAME;
					idle_height_play_nxt   = 0;
					vstart_click_play_nxt  = 0;				
					idle_width_play_nxt    = 0;
					hstart_click_play_nxt  = 0;
					hlength_click_play_nxt = 0;
					vlength_click_play_nxt = 0;
					rgb_out_rc_nxt		   = rgb_out_dr_game;
				end
				else begin
					state_nxt 			   = SCORE;
					idle_height_play_nxt   = 0;
					vstart_click_play_nxt  = 0;				
					idle_width_play_nxt    = 0;
					hstart_click_play_nxt  = 0;
					hlength_click_play_nxt = 0;
					vlength_click_play_nxt = 0;
					rgb_out_rc_nxt 		   = rgb_out_dr_game;
				end
			SCORE:
				if(mouse_clicked_stop) begin
					state_nxt 			   = IDLE;
					idle_height_play_nxt   = 376;
					vstart_click_play_nxt  = 376;				
					idle_width_play_nxt    = 492;
					hstart_click_play_nxt  = 492;
					hlength_click_play_nxt = 300;
					vlength_click_play_nxt = 100;
					rgb_out_rc_nxt = rgb_out_rc_play;
				end
				else begin
					state_nxt			   = SCORE;
					rgb_out_rc_nxt 		   = rgb_out_rc_score;
					idle_height_play_nxt   = 330;
					vstart_click_play_nxt  = 0;
					idle_width_play_nxt    = 460;
					hstart_click_play_nxt  = 0;
					hlength_click_play_nxt = 0;
					vlength_click_play_nxt = 0;
				end
			default:
				begin
					state_nxt 			   = IDLE;
					idle_height_play_nxt   = 376;
					vstart_click_play_nxt  = 376;				
					idle_width_play_nxt    = 492;
					hstart_click_play_nxt  = 492;
					hlength_click_play_nxt = 300;
					vlength_click_play_nxt = 100;
					rgb_out_rc_nxt = rgb_out_rc_play;
				end
		endcase
	end
//------------------------------------------------------------------------------
// state sequential with synchronous reset
//------------------------------------------------------------------------------
always @ (posedge pclk) begin
	if (rst_d) begin
		state <= IDLE;
	end
	else
		case (state)
			IDLE:
				begin
					state			   <= state_nxt;
					idle_height_play   <= idle_height_play_nxt;
					vstart_click_play  <= vstart_click_play_nxt;
					idle_width_play    <= idle_width_play_nxt;
					hstart_click_play  <= hstart_click_play_nxt;
					hlength_click_play <= hlength_click_play_nxt;
					vlength_click_play <= vlength_click_play_nxt;
					rgb_out_rc         <= rgb_out_rc_nxt;
				end
			WAIT:
				begin
					state 			   <= state_nxt;
					rgb_out_rc         <= rgb_out_rc_nxt;
					idle_height_play   <= idle_height_play_nxt;
					idle_width_play    <= idle_width_play_nxt;
				end
			GAME:
				begin
					state			   <= state_nxt;
					rgb_out_rc         <= rgb_out_rc_nxt;
				end
			SCORE:
				begin
					state			   <= state_nxt;
					rgb_out_rc         <= rgb_out_rc_nxt;
					idle_height_play   <= idle_height_play_nxt;
					idle_width_play    <= idle_width_play_nxt;
				end
		endcase
	end
endmodule