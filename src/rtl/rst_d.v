//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   rst_d
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: safe, with FPGA sync reset
 Description:  Template for simple module with registered outputs
 */
//////////////////////////////////////////////////////////////////////////////
module rst_d (
  output reg rst_d,
  input wire locked,
  input wire clk
  );
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
reg rst_nxt;
reg [3:0] cycles, cycles_nxt;
reg rst_d_nxt;
//------------------------------------------------------------------------------
// logic
//------------------------------------------------------------------------------
always@*
begin
	if(locked == 0) begin
		rst_d_nxt = 1;
		cycles_nxt = 0;
	end
	else if(cycles == 4'b1111) begin
		rst_d_nxt = 0;
		cycles_nxt = 4'b1111;
	end
	else begin 
		rst_d_nxt = 1;
		cycles_nxt = cycles + 1;
	end
end
//------------------------------------------------------------------------------
// output register
//------------------------------------------------------------------------------
always@(posedge clk or negedge locked) begin
	if(!locked) begin
		rst_d <= 0;
		cycles <= 0;
	end
	else begin
		rst_d <= rst_d_nxt;
		cycles <= cycles_nxt;
	end
end
endmodule
