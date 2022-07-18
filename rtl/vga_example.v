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
  wire rst_d;
 
  clk_wiz_1 my_clk_wiz_0(
    .clk(clk),
    .clk75MHz(pclk),
    .clk100MHz(mclk),
    .reset(rst),
    .locked(locked)
  );

  
  rst_d my_rst_d (
	.rst_d(rst_d),
	.locked(locked),
	.clk(pclk)
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

 
  wire [11:0] rgb_out_bg, rgb_out_dr; 
  wire [11:0] rgb_out_rc, rgb_out_rc_wait, rgb_out_rc_play, rgb_out_rc_score;
  wire [11:0] pixel_addr, rgb_pixel;
  wire [11:0] xpos, ypos, xpos_out_drc, ypos_out_drc, xpos_out_mouse, ypos_out_mouse;
  wire [10:0] vcount, vcount_out_bg, vcount_out_dr, vcount_out_rc;
  wire [10:0] hcount, hcount_out_bg, hcount_out_dr, hcount_out_rc;
  wire [10:0] char_addr;
  wire [7:0] char_pixels_play, char_pixels_wait, char_pixels_score, char_xy_play, char_xy_wait, char_xy_score;
  wire [6:0] char_code_play, char_code_wait, char_code_score;
  wire [3:0] char_line_play, char_line_wait, char_line_score;
  wire vsync, vsync_out_bg, vs_out_dr, vs_out_rc;
  wire hsync, hsync_out_bg, hs_out_dr, hs_out_rc;
  wire vblnk, vblnk_out_bg, vblnk_out_dr, vblnk_out_rc;
  wire hblnk, hblnk_out_bg, hblnk_out_dr, hblnk_out_rc;
  wire mouse_left, mouse_left_out_mouse;

  
  wire [11:0] idle_height_play, idle_width_play;
  wire [10:0] hstart_click_play, vstart_click_play, hlength_click_play, vlength_click_play;
  wire rect_clicked_play,mouse_clicked_stop, uart_start;
  wire [15:0] my_score, op_score;
  wire [1:0] state;
  
  wire[9:0] hor_ran_number;
  wire[9:0] ver_ran_number;
  

//ALL STATES

  state_machine my_state_machine(
	.pclk(pclk),
	.rst_d(rst_d),
	//inputs
	.rect_clicked_play(rect_clicked_play),
	.uart_start(uart_start),
	.mouse_clicked_stop(mouse_clicked_stop),
	.rgb_out_rc_play(rgb_out_rc_play),
	.rgb_out_rc_wait(rgb_out_rc_wait),
	.rgb_out_dr_game(rgb_out_dr),
	.rgb_out_rc_score(rgb_out_rc_score),
	//outputs
	.idle_height_play(idle_height_play),
	.idle_width_play(idle_width_play),
	.vstart_click_play(vstart_click_play),
	.hstart_click_play(hstart_click_play),
	.hlength_click_play(hlength_click_play),
	.vlength_click_play(vlength_click_play),
	.rgb_out_rc(rgb_out_rc),
	.state(state)
  
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
	.state(state),
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

//MOUSE

  MouseCtl_buf my_MouseCtl_buf (
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.xpos(xpos_out_mouse),
	.ypos(ypos_out_mouse),
	.mouse_left(mouse_left_out_mouse),
	.rst(rst_d),
	.mclk(mclk),
	.pclk(pclk)
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
  
// STATE IDLE
  
  click_ctl play_click_ctl(
  //inputs
    .pclk(pclk),
    .rst(rst_d),
    .mouse_xpos(xpos),
    .mouse_ypos(ypos),
    .mouse_left(mouse_left),
	.hstart(hstart_click_play),
	.vstart(vstart_click_play),
	.hlength(hlength_click_play),
	.vlength(vlength_click_play),
	//outputs
    .rect_clicked(rect_clicked_play)     
  );

  draw_rect_char idle_rect_char (
	//inputs
  	.hcount_in(hcount_out_bg),
	.hsync_in(hsync_out_bg),
	.hblnk_in(hblnk_out_bg),
	.vcount_in(vcount_out_bg),
	.vsync_in(vsync_out_bg),
	.vblnk_in(vblnk_out_bg),
	.rgb_in(rgb_out_bg),
	.char_pixels(char_pixels_play),
	.width_start(idle_width_play),
	.height_start(idle_height_play),
	.text_color(12'hf00),
	//outputs
	.hcount_out(hcount_out_rc),
	.hsync_out(hs_out_rc),
	.hblnk_out(hblnk_out_rc),
	.vcount_out(vcount_out_rc),
	.vsync_out(vs_out_rc),
	.vblnk_out(vblnk_out_rc),
	.rgb_out(rgb_out_rc_play),
	//.addr(char_addr),
	.char_xy(char_xy_play),
	.char_line(char_line_play),
	//others
	.rst(rst_d),
	.pclk(pclk)
  );
  
  font_rom play_font_rom (
    .clk(pclk),
	.addr({char_code_play,char_line_play}),
	.char_line_pixels(char_pixels_play)
  );
  
  char_rom_play my_char_rom_play(
    .clk(pclk),
	.char_xy(char_xy_play),
	.char_code_out(char_code_play)
   );
   
// STATE WAITING

  draw_rect_char wait_rect_char (
	//inputs
  	.hcount_in(hcount_out_bg),
	.hsync_in(hsync_out_bg),
	.hblnk_in(hblnk_out_bg),
	.vcount_in(vcount_out_bg),
	.vsync_in(vsync_out_bg),
	.vblnk_in(vblnk_out_bg),
	.rgb_in(rgb_out_bg),
	.char_pixels(char_pixels_wait),
	.width_start(idle_width_play),
	.height_start(idle_height_play),
	.text_color(12'h0f0),
	//outputs
	.hcount_out(hcount_out_rc),
	.hsync_out(hs_out_rc),
	.hblnk_out(hblnk_out_rc),
	.vcount_out(vcount_out_rc),
	.vsync_out(vs_out_rc),
	.vblnk_out(vblnk_out_rc),
	.rgb_out(rgb_out_rc_wait),
	//.addr(char_addr),
	.char_xy(char_xy_wait),
	.char_line(char_line_wait),
	//others
	.rst(rst_d),
	.pclk(pclk)
  );
  
  font_rom wait_font_rom (
    .clk(pclk),
	.addr({char_code_wait,char_line_wait}),
	.char_line_pixels(char_pixels_wait)
  );
  
  char_rom_wait my_char_rom_wait(
    .clk(pclk),
	.char_xy(char_xy_wait),
	.char_code_out(char_code_wait)
   );
   
// STATE GAME

   ran_num_gen my_ran_num_gen(
    .clk(pclk),
	.rst(rst_d),
	.state(state),
	.hor_data(hor_ran_number),
	.ver_data(ver_ran_number)
   );

  draw_rect duck_image (
	//inputs
	.vcount_in(vcount_out_bg),
  	.hcount_in(hcount_out_bg),
	.rgb_in(rgb_out_bg),
	.xpos({2'b00,hor_ran_number}),
	.ypos({2'b00,ver_ran_number}),
	.rgb_pixel(rgb_pixel),
	.vsync_in(vsync_out_bg),
	.vblnk_in(vblnk_out_bg),
	.hsync_in(hsync_out_bg),
	.hblnk_in(hblnk_out_bg),
	//outputs
	.vcount_out(vcount_out_dr),
	.hcount_out(hcount_out_dr),
	.rgb_out(rgb_out_dr),
	.pixel_addr(pixel_addr),
	.vsync_out(vs_out_dr),
	.vblnk_out(vblnk_out_dr),
	.hsync_out(hs_out_dr),
	.hblnk_out(hblnk_out_dr),
	//others
	.rst(rst_d),
	.pclk(pclk)
   );
   image_rom my_image_rom(
	 .clk(pclk),
	 .rst(rst_d),
	 .address(pixel_addr),
	 .rgb(rgb_pixel)
   );
   
    sync_after_image my_sync_after_image(
	 .pclk(pclk),
	 .rst(rst_d),
	 .vs_in(vs_out_dr),
	 .hs_in(hs_out_dr),
	 .hcount_in(hcount_out_dr),
	 .vcount_in(vcount_out_dr),
	 .vblnk_in(vblnk_out_dr),
	 .hblnk_in(hblnk_out_dr),
	 .hs_out(hs_out_rc),
	 .vs_out(vs_out_rc),
	 .hcount(hcount_out_rc),
	 .vcount(vcount_out_rc),
	 .vblnk(vblnk_out_rc),
	 .hblnk(hblnk_out_rc)
   );
   
   
// STATE SCORE
   
  draw_rect_char score_rect_char (
	//inputs
  	.hcount_in(hcount_out_bg),
	.hsync_in(hsync_out_bg),
	.hblnk_in(hblnk_out_bg),
	.vcount_in(vcount_out_bg),
	.vsync_in(vsync_out_bg),
	.vblnk_in(vblnk_out_bg),
	.rgb_in(rgb_out_bg),
	.char_pixels(char_pixels_score),
	.width_start(idle_width_play),
	.height_start(idle_height_play),
	.text_color(12'h00f),
	//outputs
	.hcount_out(hcount_out_rc),
	.hsync_out(hs_out_rc),
	.hblnk_out(hblnk_out_rc),
	.vcount_out(vcount_out_rc),
	.vsync_out(vs_out_rc),
	.vblnk_out(vblnk_out_rc),
	.rgb_out(rgb_out_rc_score),
	//.addr(char_addr),
	.char_xy(char_xy_score),
	.char_line(char_line_score),
	//others
	.rst(rst_d),
	.pclk(pclk)
  );
  
  font_rom score_font_rom (
    .clk(pclk),
	.addr({char_code_score,char_line_score}),
	.char_line_pixels(char_pixels_score)
  );
  
  char_rom_score my_char_rom_score(
    .clk(pclk),
	.char_xy(char_xy_score),
	.char_code_out(char_code_score),
	.my_score(14'h3132),
	.op_score(14'h3334),
	.number_of_player(7'h32)
   );
   

endmodule
