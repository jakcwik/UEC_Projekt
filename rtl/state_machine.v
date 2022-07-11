
module state_machine (
input wire pclk,
input wire rect_clicked_play,
input wire rst_d,
input wire uart_start,
input wire game_timer,
input wire mouse_clicked_stop,
input wire [11:0] rgb_out_rc_play,
input wire [11:0] rgb_out_rc_wait,
output reg [11:0] idle_height_play,
output reg [10:0] vstart_click_play,
output reg [11:0] idle_width_play,
output reg [10:0] hstart_click_play,
output reg [10:0] hlength_click_play,
output reg [10:0] vlength_click_play,
output reg [11:0] rgb_out_rc
);


reg[1:0] state, state_nxt;
reg[11:0]  rgb_out_rc_nxt;
reg[11:0]  idle_height_play_nxt, idle_width_play_nxt;
reg[10:0]  hstart_click_play_nxt, vstart_click_play_nxt, hlength_click_play_nxt, vlength_click_play_nxt;

parameter IDLE = 2'b00, WAIT = 2'b01, GAME = 2'b10, SCORE = 2'b11;


always@* begin
	if (rst_d) begin
		state_nxt <= IDLE;
	end
	else
		case (state)
			IDLE:
				if (rect_clicked_play == 1) begin
					state_nxt = WAIT;
					idle_height_play_nxt   = 0;
					vstart_click_play_nxt  = 0;
					idle_width_play_nxt    = 0;
					hstart_click_play_nxt  = 0;
					hlength_click_play_nxt = 0;
					vlength_click_play_nxt = 0;
					rgb_out_rc_nxt = rgb_out_rc_wait;
				end
				else begin
					state_nxt <= IDLE;
					idle_height_play_nxt   = 186;
					vstart_click_play_nxt  = 186;				
					idle_width_play_nxt    = 380;
					hstart_click_play_nxt  = 380;
					hlength_click_play_nxt = 300;
					vlength_click_play_nxt = 100;
					rgb_out_rc_nxt = rgb_out_rc_play;
				end
			WAIT:
				if (rect_clicked_play & uart_start) begin
					state_nxt <= GAME;
					rgb_out_rc_nxt <= rgb_out_rc_wait;
				end
				else begin
					state_nxt <= WAIT;
					rgb_out_rc_nxt <= rgb_out_rc_wait;
				end
			GAME:
				if (game_timer == 0)
					state_nxt <= SCORE;
				else if(mouse_clicked_stop)
					state_nxt <= IDLE;
				else
					state_nxt <= IDLE;
		endcase
	end

always @ (posedge pclk) begin
	if (rst_d) begin
		state <= IDLE;
	end
	else
		case (state)
			IDLE:
				begin
					state <= state_nxt;
					idle_height_play   <= idle_height_play_nxt;
					vstart_click_play  <= vstart_click_play_nxt;
					idle_width_play    <= idle_width_play_nxt;
					hstart_click_play  <= hstart_click_play_nxt;
					hlength_click_play <= hlength_click_play_nxt;
					vlength_click_play <= vlength_click_play_nxt;
					rgb_out_rc         <= rgb_out_rc_nxt;
				end
			WAIT:
				if (rect_clicked_play & uart_start) begin
					state <= state_nxt;
					rgb_out_rc         <= rgb_out_rc_nxt;
				end
				else begin
					state <= state_nxt;
					rgb_out_rc         <= rgb_out_rc_nxt;
				end
			GAME:
				if (game_timer == 0)
					state <= state_nxt;
				else if(mouse_clicked_stop)
					state <= state_nxt;
				else
					state <= state_nxt;
		endcase
	end
endmodule