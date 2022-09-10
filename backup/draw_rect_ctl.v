`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   draw_rect_ctl
 Author:        Robert Szczygiel
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:  Template for simple module with registered outputs
 */
//////////////////////////////////////////////////////////////////////////////
module draw_rect_ctl(
	//inputs
    input wire [11:0] mouse_xpos, 
    input wire [11:0] mouse_ypos, 
	input wire mouse_left,
	input wire rst,
    input wire pclk,
    //outputs
    output reg [11:0] xpos,
    output reg [11:0] ypos
    );
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------
    localparam WIDTH='d48, HEIGHT='d64, COLOR=12'h0_f_0;
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
    reg [11:0] xpos_nxt, ypos_nxt, xpos_const;
	reg clicked_mouse, clicked_mouse_nxt;
    reg [31:0] ypos_down; //Q12.20
	reg [19:0] counter;
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@*
	if ((ypos_down > 0) && (ypos_down[31:20] < 600 - HEIGHT)) begin
		xpos_nxt = xpos_const;
		ypos_nxt = ypos_down[31:20];
	end
	else if(ypos_down[31:20] >= 600 - HEIGHT)begin
		xpos_nxt = xpos_const;
		ypos_nxt = 600 - HEIGHT;
	end
	else begin
		xpos_nxt = mouse_xpos;
		ypos_nxt = mouse_ypos;
	end
	
always@* begin
	if(mouse_left == 1) begin
		clicked_mouse_nxt = 1;
	end
	else
		clicked_mouse_nxt = clicked_mouse;
end


always@(posedge pclk)
	if(rst) begin
		ypos_down <= 0;
		xpos_const <= 0;
		counter <= 20'h8_f_f_f_7;
	end
	else begin
		if(ypos_down[19:0] == counter)begin
			ypos_down[31:20] <= ypos_down[31:20] + 1;
			ypos_down[19:0] <= 0;
			counter <= counter - 982; 
		end
		else if((clicked_mouse_nxt == 1) && (ypos_down == 0) )begin
			ypos_down[31:20] <= mouse_ypos + 1;
			xpos_const <= xpos_const;
		end
		else if((clicked_mouse_nxt == 1) && (ypos_down[31:20] < 600 - HEIGHT))begin
			ypos_down <= ypos_down + 1;
 			xpos_const <= xpos_const;
		end
		else if (clicked_mouse_nxt == 1)begin
			ypos_down <= ypos_down;
			xpos_const <= xpos_const;
		end
		else begin
			ypos_down <= 0;
			xpos_const <= mouse_xpos;
		end
	end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always@(posedge pclk)
	if(rst) begin
		xpos <= 0;
		ypos <= 0;
		clicked_mouse <=0;
	end
	else begin
		xpos <= xpos_nxt;
		ypos <= ypos_nxt;
		clicked_mouse <= clicked_mouse_nxt;
	end
endmodule
