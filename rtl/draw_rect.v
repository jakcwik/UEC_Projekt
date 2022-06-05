// File: draw_rect.v


// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect (
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire [11:0] rgb_in,
  input wire [11:0] xpos,
  input wire [11:0] ypos,
  input wire [11:0] rgb_pixel,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  output reg [10:0] vcount_out,
  output reg [10:0] hcount_out,
  output reg [11:0] rgb_out,
  output reg [11:0] pixel_addr,
  output reg vsync_out,
  output reg vblnk_out,
  output reg hsync_out,
  output reg hblnk_out,
  input wire pclk,
  input wire rst
  );

//Next state registers
reg [11:0] rgb_nxt, rgb_nxt_d, rgb_nxt_d2;
reg [10:0] addrx, addry;
reg hsync_d, vsync_d, hblnk_d, vblnk_d, hsync_d2, vsync_d2, hblnk_d2, vblnk_d2;
reg [10:0] hcount_d, vcount_d, hcount_d2, vcount_d2;

//LOCAL PARAMETERS
localparam RECT_WIDTH  = 48;
localparam RECT_HEIGHT = 64;
localparam RECT_COLOR  = 12'hd_d_9;

always@*
    if ((hcount_d2>= xpos) && (hcount_d2< xpos + RECT_WIDTH) && (vcount_d2 >= ypos) && (vcount_d2 < ypos + RECT_HEIGHT) && (rgb_pixel == 3'h000))
		begin
		rgb_nxt = 12'h0_f_0;
		addry = vcount_in - ypos;
		addrx = hcount_in - xpos;
		end
    else begin
		rgb_nxt = rgb_nxt_d2;
		addry = vcount_in - ypos;
		addrx = hcount_in - xpos;
		end
	

always @(posedge pclk)begin
		hcount_d <= hcount_in;
		hsync_d  <= hsync_in;
		hblnk_d  <= hblnk_in;
		vcount_d <= vcount_in;
		vsync_d  <= vsync_in;
		vblnk_d  <= vblnk_in;
		rgb_nxt_d <= rgb_in;
	end
	
	always @(posedge pclk)begin
		hcount_d2 <= hcount_d;
		hsync_d2  <= hsync_d;
		hblnk_d2  <= hblnk_d;
		vcount_d2 <= vcount_d;
		vsync_d2  <= vsync_d;
		vblnk_d2  <= vblnk_d;
		rgb_nxt_d2 <= rgb_nxt_d;
	end
	


always @(posedge pclk)
	if(rst) begin
		hcount_out <= 0;
		hsync_out  <= 0;
		hblnk_out  <= 0;
		vcount_out <= 0;
		vsync_out  <= 0;
		vblnk_out  <= 0;
		rgb_out    <= 0;
	end
	else begin
		hcount_out <= hcount_d2;
		hsync_out  <= hsync_d2;
		hblnk_out  <= hblnk_d2;
		vcount_out <= vcount_d2;
		vsync_out  <= vsync_d2;
		vblnk_out  <= vblnk_d2;
		rgb_out    <= rgb_nxt;
		pixel_addr <= {addry[5:0], addrx[5:0]};
	end




endmodule