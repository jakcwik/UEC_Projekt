module state_machine (
input wire  clk;
input wire in;
input wire reset;
input wire start_game_uart;
output reg [1:0] state_out;
);


reg     [1:0]state_out; //bylo out
reg     [1:0]state;

parameter IDLE = 0, WAIT = 1, GAME = 2, SCORE = 3;


always @ (state) begin
	case (state)
	IDLE:
	   state_out = 2'b00;
	WAIT:
	   state_out = 2'b01;
	GAME:
	   state_out = 2'b10;
	SCORE:
	   state_out = 2'b11;
	default:
	   state_out = 2'b00;
	endcase
end

always @ (posedge clk) begin
	if (reset)
		state <= IDLE;
	else
		case (state)
			IDLE:
				if (mouse_clicked_start)
					state <= WAIT;
				else
					state <= IDLE;
			WAIT:
				if (mouse_clicked_start && start_game_uart)
					state <= GAME;
				else
					state <= WAIT;
			GAME:
				if (game_timer == 0)
					state <= SCORE;
				else if(mouse_clicked_stop)
					state <= IDLE
				else
					state <= IDLE;
		endcase
	end
endmodule