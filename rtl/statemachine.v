module state_machine (
input wire  clk;
input wire in;
input wire reset;
output reg  [1:0]out;
);


reg     [1:0]out;
reg     [1:0]state;

parameter IDLE = 0, WAIT = 1, GAME = 2, SCORE = 3;


always @ (state) begin
	case (state)
	IDLE:
	   out = 2'b00;
	WAIT:
	   out = 2'b01;
	GAME:
	   out = 2'b10;
	SCORE:
	   out = 2'b11;
	default:
	   out = 2'b00;
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
				if (mouse_clicked_start & uart_start)
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