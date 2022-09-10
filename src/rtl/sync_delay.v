`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   sync_delay
 Author:        Jakub Ćwik
 Version:       1.0
 Last modified: 2022-04-03
 Coding style: safe, with FPGA sync reset
 Description:  Template for simple module with registered outputs
 */
//////////////////////////////////////////////////////////////////////////////
module sync_delay (
  //inputs
  input wire vs_in,
  input wire hs_in,
  input wire blank,
  input wire [11:0] rgb_in,
  input wire [10:0] hcount,
  input wire [10:0] vcount,
  input wire [11:0] xpos,
  input wire [11:0] ypos,
  //outputs
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  output reg [10:0] hcount_out, vcount_out,
  output wire hblnk_out, vblnk_out,
  output reg vs_out,
  output reg hs_out,
  //clock and reset
  input wire pclk,
  input wire rst
  );
//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
wire [3:0] r_out,g_out,b_out;
reg[10:0] vcount_d, hcount_d;
reg vs_d, hs_d;
//wire [11:0] pixel_addr_s, rgb_pixel_s;
//wire [11:0] rgb_out;
/*
   draw_rect celownik(
	//inputs
  	.hcount_in(hcount),
	.hsync_in(hs_in),
	.hblnk_in(hblnk),
	.vcount_in(vcount),
	.vsync_in(vs_in),
	.vblnk_in(vblnk),
	.rgb_in(rgb_in),
	.rgb_pixel(rgb_pixel_s),
	.xpos(xpos),
	.ypos(ypos),
	//outputs
	.hcount_out(hcount_out),
	.hsync_out(hs_out),
	.hblnk_out(hblnk_out),
	.vcount_out(vcount_out),
	.vsync_out(vs_out),
	.vblnk_out(vblnk_out),
	.rgb_out(rgb_out),
	.pixel_addr(pixel_addr_s),
	//others
	.rst(rst),
	.pclk(pclk)
  );
  
   celownik_rom my_celownik_rom (
    .clk(pclk),
	.address(pixel_addr_s),
	.rgb(rgb_pixel_s)
  );
  */
  MouseDisplay my_MouseDisplay (
     //inputs
    .pixel_clk(pclk),
    .xpos(xpos),
    .ypos(ypos),
    .hcount(hcount),
    .vcount(vcount),
    .blank(blank),
    .red_in(rgb_in[11:8]),
    .green_in(rgb_in[7:4]),
    .blue_in(rgb_in[3:0]),
    //outputs
    .red_out(r_out),
    .green_out(g_out),
    .blue_out(b_out)
  );
//------------------------------------------------------------------------------
// synchonization delay
//------------------------------------------------------------------------------
always @(posedge pclk) begin
		vs_d  <= vs_in;
		hs_d  <= hs_in;
		vcount_d <= vcount;
		hcount_d <= hcount;
	end
//------------------------------------------------------------------------------
// output register with sync reset
//------------------------------------------------------------------------------
always @(posedge pclk)
	if(rst) begin
		vs_out  <=0;
		hs_out  <=0;
	end
	else begin
		vcount_out <= vcount_d;
		hcount_out <= hcount_d;
		vs_out	<=vs_d;
		hs_out  <=hs_d;
		r		<=r_out;
		g		<=g_out;
		b		<=b_out;
	end
endmodule