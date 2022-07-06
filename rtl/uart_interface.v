module uart_interface(

    input wire clk;
    input wire [7:0] get_uart;
    //input wire tx_full, rx_empty;
    input wire my_score;

    output reg [7:0] send_uart;
    output reg rd_uart, wr_uart;

    output reg uart_start;
    output reg score_2nd_player
); 

localparam 8'hFF = START_SIGNAL ;

always@*
    case(state_in)
        //IDLE:
        WAIT: //wyslij informacje o starcie, czekaj na informacje o starcie
            /*if(!tx_full)*/ begin 
                send_uart = START_SIGNAL;
                wr_uart = 1'b1
            end
            if(/*!rx_empty &&*/ get_uart == START_SIGNAL) begin
                uart_start = 1'b1;
                rd_uart = 1'b1;
            end
            else begin
                uart_start = 1'b0;
                rd_uart = 1'b0;
            end
        //GAME:
        SCORE: 
            /*if(!rx_empty) */begin 
                score_2nd_player = get_uart;
                rd_uart = 1'b0;
            end
            /*if(!tx_full) */ begin 
                send_uart = my_score;
                wr_uart = 1'b1
            end
        default: begin
            uart_start = 1'b0;
            rd_uart = 1'b0;
        end
    endcase
