// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  inout wire ps2_clk,
  inout wire ps2_data,
  input wire clk,
  input wire rst, 
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire pclk_mirror
  );


  wire locked;
  wire pclk, mclk;
 
  clk_wiz_0 my_clk_wiz_0(
    .clk(clk),
    .clk40MHz(pclk),
    .clk100MHz(mclk),
    .reset(rst),
    .locked(locked)
  );

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );

 
  wire [11:0] rgb_out_bg, rgb_out_dr, rgb_out_rc, pixel_addr, rgb_pixel;
  wire [11:0] xpos, ypos, xpos_out_drc, ypos_out_drc, xpos_out_mouse, ypos_out_mouse;
  wire [10:0] vcount, vcount_out_bg, vcount_out_dr, vcount_out_rc;
  wire [10:0] hcount, hcount_out_bg, hcount_out_dr, hcount_out_rc;
  wire [10:0] char_addr;
  wire [7:0] char_pixels, char_xy;
  wire [6:0] char_code;
  wire [3:0] char_line;
  wire vsync, vsync_out_bg, vs_out_dr, vs_out_rc;
  wire hsync, hsync_out_bg, hs_out_dr, hs_out_rc;
  wire vblnk, vblnk_out_bg, vblnk_out_dr, vblnk_out_rc;
  wire hblnk, hblnk_out_bg, hblnk_out_dr, hblnk_out_rc;
  wire mouse_left, mouse_left_out_mouse;
  wire en_m;
  wire rst_d;
  
  reg[1:0] state;
  reg [11:0] height_start, width_start;
  wire game_timer, mouse_clicked_start,mouse_clicked_stop, uart_start;
  
  parameter IDLE = 0, WAIT = 1, GAME = 2, SCORE = 3;

  rst_d my_rst_d (
	.rst_d(rst_d),
	.locked(locked),
	.clk(pclk)
  );
  
  sync_delay my_sync_delay (
  	//inputs
	.vs_in(vs_out_rc),
	.hs_in(hs_out_rc),
	 //inputs from draw_rect
    .xpos(xpos),
    .ypos(ypos),
    .hcount(hcount_out_rc),
    .vcount(vcount_out_rc),
    .hblnk(hblnk_out_rc),
	.vblnk(vblnk_out_rc),
    .rgb_in(rgb_out_rc[11:0]),
	//outputs
	.vs_out(vs),
	.hs_out(hs),
    //outputs from draw_rect
    .r(r),
    .g(g),
    .b(b),
	//clock and reset
	.rst(rst_d),
	.mclk(mclk),
	.pclk(pclk)
  );

  vga_timing my_timing (
	//outputs
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
	//clock and reset
    .pclk(pclk),
    .rst(rst_d)  
  );

  draw_background my_background (
	//inputs
	.hcount_in(hcount),
	.hsync_in(hsync),
	.hblnk_in(hblnk),
	.vcount_in(vcount),
	.vsync_in(vsync),
	.vblnk_in(vblnk),
	//outputs
	.hsync_out(hsync_out_bg),
	.hblnk_out(hblnk_out_bg),
	.vcount_out(vcount_out_bg),
	.hcount_out(hcount_out_bg),
	.vsync_out(vsync_out_bg),
	.vblnk_out(vblnk_out_bg),
	.rgb_out(rgb_out_bg),
	//others
	.rst(rst_d),
	.pclk(pclk)
  );
  /*
  draw_rect my_rect (
	//inputs
  	.hcount_in(hcount_out_bg),
	.hsync_in(hsync_out_bg),
	.hblnk_in(hblnk_out_bg),
	.vcount_in(vcount_out_bg),
	.vsync_in(vsync_out_bg),
	.vblnk_in(vblnk_out_bg),
	.rgb_in(rgb_out_bg),
	.rgb_pixel(),
	//outputs
	.hcount_out(hcount_out_dr),
	.hsync_out(hs_out_dr),
	.hblnk_out(hblnk_out_dr),
	.vcount_out(vcount_out_dr),
	.vsync_out(vs_out_dr),
	.vblnk_out(vblnk_out_dr),
	.rgb_out(rgb_out_dr),
	.xpos(xpos_out_drc),
	.ypos(ypos_out_drc),
	.pixel_addr(),
	//others
	.rst(rst_d),
	.pclk(pclk)
  );
  */
  draw_rect_ctl my_draw_rect_ctl(
  //inputs
    .pclk(pclk),
    .rst(rst_d),
    .mouse_xpos(xpos),
    .mouse_ypos(ypos),
    .mouse_left(mouse_left),
	//outputs
    .xpos(xpos_out_drc),
    .ypos(ypos_out_drc)     
  );

  MouseCtl my_MouseCtl (
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.xpos(xpos_out_mouse),
	.ypos(ypos_out_mouse),
	.left(mouse_left_out_mouse),
	.rst(rst_d),
	.clk(mclk)
  );
  
   cursor_sync my_cursor_sync (
	.xpos(xpos_out_mouse),
	.ypos(ypos_out_mouse),
	.left(mouse_left_out_mouse),
	.xpos_out(xpos),
	.ypos_out(ypos),
	.left_out(mouse_left),
	.rst(rst_d),
	.pclk(pclk)
  );
  
    draw_rect_char start_rect_char (
	//inputs
  	.hcount_in(hcount_out_bg),
	.hsync_in(hsync_out_bg),
	.hblnk_in(hblnk_out_bg),
	.vcount_in(vcount_out_bg),
	.vsync_in(vsync_out_bg),
	.vblnk_in(vblnk_out_bg),
	.rgb_in(rgb_out_bg),
	.char_pixels(char_pixels),
	.width_start(width_start),
	.height_start(height_start),
	//outputs
	.hcount_out(hcount_out_rc),
	.hsync_out(hs_out_rc),
	.hblnk_out(hblnk_out_rc),
	.vcount_out(vcount_out_rc),
	.vsync_out(vs_out_rc),
	.vblnk_out(vblnk_out_rc),
	.rgb_out(rgb_out_rc),
	//.addr(char_addr),
	.char_xy(char_xy),
	.char_line(char_line),
	//others
	.rst(rst_d),
	.pclk(pclk)
  );
  
   font_rom start_font_rom (
    .clk(pclk),
	.addr({char_code,char_line}),
	.char_line_pixels(char_pixels)
  );
  
   char_rom_16x16 start_char_rom_16x16(
    .clk(pclk),
	.char_xy(char_xy),
	.char_code_out(char_code)
   );
   


always @ (posedge clk) begin
	if (rst_d) begin
		state <= IDLE;
		height_start <= 186;
		width_start <= 380;
	end
	else
		case (state)
			IDLE:
				if (mouse_clicked_start)
					state <= WAIT;
				else begin
					state <= IDLE;
					height_start <= 192;
					width_start <= 360;
				end
			WAIT:
				if (mouse_clicked_start & uart_start)
					state <= GAME;
				else
					state <= WAIT;
			GAME:
				if (game_timer == 0)
					state <= SCORE;
				else if(mouse_clicked_stop)
					state <= IDLE;
				else
					state <= IDLE;
		endcase
	end

   
   

  

endmodule