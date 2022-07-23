// File: draw_rect.v


// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_char (
  input wire [10:0] vcount_in,
  input wire [10:0] hcount_in,
  input wire [11:0] rgb_in,
  input wire [11:0] text_color,
  input wire [7:0] char_pixels,
  input wire vsync_in,
  input wire vblnk_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] width_start,
  input wire [11:0] height_start,
  output reg [10:0] vcount_out,
  output reg [10:0] hcount_out,
  output reg [11:0] rgb_out,
  output reg [7:0] char_xy,
  output reg [3:0] char_line,
  output reg vsync_out,
  output reg vblnk_out,
  output reg hsync_out,
  output reg hblnk_out,
  input wire pclk,
  input wire rst
  );

reg [11:0] rgb_nxt, rgb_nxt_d, rgb_nxt_d2, rgb_d, rgb_d2, rgb_d3, rgb_d4;
reg [10:0] hcount_d, vcount_d, hcount_d2, vcount_d2, hcount_d3, vcount_d3,  hcount_d4, vcount_d4;
reg [7:0] char_xy_nxt, char_xy_d, char_pixels_d;
reg [3:0] char_line_nxt, char_line_d;
reg [3:0] rect_height_offset;
reg [2:0] rect_width_offset;
reg hsync_d, vsync_d, hblnk_d, vblnk_d, hsync_d2, vsync_d2, hblnk_d2, vblnk_d2, hsync_d3, vsync_d3, hblnk_d3, vblnk_d3,  hsync_d4, vsync_d4, hblnk_d4, vblnk_d4;


localparam RECT_WIDTH  = 128;
localparam RECT_HEIGHT = 64;



always@* begin
	//HEIGHT OFFSET - żeby startowało bez względu na vcount
	if(height_start % 16 == 0)begin
		rect_height_offset = 0;
	end
	else begin
		rect_height_offset = vcount_in[3:0] < height_start[3:0] ? 1 : 0;
	end
	//WIDTH OFFSET - żeby startowało bez względu na hcount
	if((width_start - 1) % 8 == 0)begin
		rect_width_offset = 0;
	end
	else begin
		rect_width_offset = hcount_in[2:0] < width_start[2:0] ? 1 : 0;
	end
	//ograniczenie wyświetlania tekstu do prostokąta
	//dane przed opóźnieniem - ustawienie dobrej pozycji początkowej dla wyświetlanego tekstu
	if((hcount_in>= width_start) && (hcount_in < width_start + RECT_WIDTH) && (vcount_in >= height_start) && (vcount_in < height_start + RECT_HEIGHT))begin
		char_xy_nxt = {vcount_in[7:4] - height_start[7:4] - rect_height_offset, hcount_in[6:3] - width_start[6:3] - rect_width_offset};
		char_line_nxt = vcount_in[3:0] - height_start[3:0];
	end
	else begin
		char_xy_nxt = char_xy;
		char_line_nxt = char_line;
	end
	//dane po opóźnieniu - wyświetlanie tekstu
	if ((hcount_d3>= width_start) && (hcount_d3 < width_start + RECT_WIDTH) && (vcount_d3 >= height_start) && (vcount_d3 < height_start + RECT_HEIGHT))begin
		if (char_pixels_d[3'b111-hcount_in[2:0]] != 0) begin
			rgb_nxt = text_color;
		end
		else begin
			rgb_nxt = rgb_d3;
		end
	end
	else begin
		rgb_nxt = rgb_d3;
	end
end


always @(posedge pclk)begin
		hcount_d <= hcount_in;
		hsync_d  <= hsync_in;
		hblnk_d  <= hblnk_in;
		vcount_d <= vcount_in;
		vsync_d  <= vsync_in;
		vblnk_d  <= vblnk_in;
		rgb_d    <= rgb_in;
		char_xy_d<= char_xy_nxt;
		char_line_d <= char_line_nxt;
		char_pixels_d <= char_pixels;
		rgb_nxt_d <= rgb_nxt;
	end
	
always @(posedge pclk)begin
		hcount_d2 <= hcount_d;
		hsync_d2  <= hsync_d;
		hblnk_d2  <= hblnk_d;
		vcount_d2 <= vcount_d;
		vsync_d2  <= vsync_d;
		vblnk_d2  <= vblnk_d;
		rgb_d2    <= rgb_d;
		rgb_nxt_d2 <= rgb_nxt_d;
	end
	

always @(posedge pclk)begin
		hcount_d3 <= hcount_d2;
		hsync_d3  <= hsync_d2;
		hblnk_d3  <= hblnk_d2;
		vcount_d3 <= vcount_d2;
		vsync_d3  <= vsync_d2;
		vblnk_d3  <= vblnk_d2;
		rgb_d3    <= rgb_d2;
	end
	
always @(posedge pclk)begin
		hcount_d4 <= hcount_d3;
		hsync_d4  <= hsync_d3;
		hblnk_d4  <= hblnk_d3;
		vcount_d4 <= vcount_d3;
		vsync_d4  <= vsync_d3;
		vblnk_d4  <= vblnk_d3;
		rgb_d4    <= rgb_d3;
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
		char_xy    <= 0;
		char_line  <= 0;
	end
	else begin
		hcount_out <= hcount_d3;
		hsync_out  <= hsync_d3;
		hblnk_out  <= hblnk_d3;
		vcount_out <= vcount_d3;
		vsync_out  <= vsync_d3;
		vblnk_out  <= vblnk_d3;
		rgb_out    <= rgb_nxt;
		char_xy    <= char_xy_nxt;
		char_line  <= char_line_d;
	end




endmodule