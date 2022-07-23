
`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module sync_delay (
  //inputs
  input wire vs_in,
  input wire hs_in,
  input wire hblnk,
  input wire vblnk,
  input wire [11:0] rgb_in,
  input wire [10:0] hcount,
  input wire [10:0] vcount,
  input wire [11:0] xpos,
  input wire [11:0] ypos,
  //outputs
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  output wire [10:0] hcount_out, vcount_out,
  output wire hblnk_out, vblnk_out,
  output wire vs_out,
  output wire hs_out,
  //clock and reset
  input wire pclk,
  input wire rst
  );
  
  
//next state registers and wires
wire vs_d, hs_d;
wire [11:0] pixel_addr_s, rgb_pixel_s;
wire [11:0] rgb_out;

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
  
   image_rom my_image_rom (
    .clk(pclk),
	.address(pixel_addr_s),
	.rgb(rgb_pixel_s)
  );
  
 /* MouseDisplay my_MouseDisplay (
     //inputs
    .pixel_clk(pclk),
    .xpos(xpos),
    .ypos(ypos),
    .hcount(hcount),
    .vcount(vcount),
    .blank(blank),
    .red_in(red_in),
    .green_in(green_in),
    .blue_in(blue_in),
    //outputs
    .enable_mouse_display_out(en_m), // czy wyswietlac kursor?
    .red_out(r_out),
    .green_out(g_out),
    .blue_out(b_out)
  );

*/



always @(posedge pclk)
	if(rst) begin
		r		<=0;
		g		<=0;
		b		<=0;	
	end
	else begin
		r		<=rgb_out[11:8];
		g		<=rgb_out[7:4];
		b		<=rgb_out[3:0];
	end
endmodule