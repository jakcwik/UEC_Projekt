`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   sync_after_image
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2020-08-20
 Coding style: safe, with FPGA sync reset
 Description:  This module provides correct synchronization after the signal has passed through the rom memory.
 */
//////////////////////////////////////////////////////////////////////////////
module sync_after_image (
  //inputs
  input wire vs_in,
  input wire hs_in,
  input wire hblnk_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire [10:0] vcount_in,
  input wire [11:0] rgb_in,
  //outputs
  output reg hblnk,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg [10:0] vcount,
  output reg vs_out,
  output reg hs_out,
  output reg[11:0] rgb_out,
  //clock and reset
  input wire pclk,
  input wire rst
  );
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
 reg [10:0] hcount_d, vcount_d, hcount_d2, vcount_d2, hcount_d3, vcount_d3;
 reg vs_out_d, hs_out_d, vblnk_d, hblnk_d, vs_out_d2, hs_out_d2, vblnk_d2, hblnk_d2, vs_out_d3, hs_out_d3, hblnk_d3, vblnk_d3;
//------------------------------------------------------------------------------
// delay
//------------------------------------------------------------------------------  
always @(posedge pclk)
	if(rst) begin
		vs_out_d  <=0;
		hs_out_d  <=0;
		hblnk_d	  <=0;
		vblnk_d	  <=0;
		hcount_d  <=0;
		vcount_d  <=0;	
	end
	else begin
		vs_out_d	<=vs_in;
		hs_out_d  <=hs_in;
		hblnk_d		<=hblnk_in;
		vblnk_d		<=vblnk_in;
		hcount_d		<=hcount_in;
		vcount_d		<=vcount_in;
	end

always @(posedge pclk)
	if(rst) begin
		vs_out_d2  <=0;
		hs_out_d2  <=0;
		hblnk_d2	  <=0;
		vblnk_d2	  <=0;
		hcount_d2  <=0;
		vcount_d2  <=0;	
	end
	else begin
		vs_out_d2	<=vs_out_d;
		hs_out_d2  <=hs_out_d;
		hblnk_d2		<=hblnk_d;
		vblnk_d2		<=vblnk_d;
		hcount_d2		<=hcount_d;
		vcount_d2		<=vcount_d;
	end

always @(posedge pclk)
	if(rst) begin
		vs_out_d3  <=0;
		hs_out_d3  <=0;
		hblnk_d3  <=0;
		vblnk_d3	 <=0;
		hcount_d3  <=0;
		vcount_d3  <=0;	
	end
	else begin
		vs_out_d3	<=vs_out_d2;
		hs_out_d3  <=hs_out_d2;
		hblnk_d3		<=hblnk_d2;
		vblnk_d3		<=vblnk_d2;
		hcount_d3		<=hcount_d2;
		vcount_d3		<=vcount_d2;
	end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always @(posedge pclk)
	if(rst) begin
		vs_out  <=0;
		hs_out  <=0;
		hblnk		<=0;
		vblnk		<=0;
		hcount		<=0;
		vcount		<=0;
		rgb_out     <=0;
	end
	else begin
		vs_out	<=vs_out_d;
		hs_out  <=hs_out_d;
		hblnk		<=hblnk_d;
		vblnk		<=vblnk_d;
		hcount		<=hcount_d;
		vcount		<=vcount_d;
		rgb_out     <=rgb_in;
	end
endmodule