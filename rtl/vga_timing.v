// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  output reg [10:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg hsync,
  output reg hblnk,
  input wire pclk,
  input wire rst //add rst wire
  );

//LOCAL PARAMETERS
//Horizontal

localparam HOR_BLNK_START = 1024;
localparam HOR_SYNC_START = 1048;
localparam HOR_SYNC_TIME  = 136;
localparam HOR_BLNK_TIME  = 304;
localparam HOR_TOT_TIME = 1328;
//Vertical
localparam VER_TOT_TIME = 806;
localparam VER_BLNK_START = 768; 
localparam VER_BLNK_TIME  = 38;
localparam VER_SYNC_START = 771;
localparam VER_SYNC_TIME  = 6;

//Next state registers
reg [10:0] hcount_nxt, vcount_nxt;
reg hsync_nxt, vsync_nxt, vblnk_nxt, hblnk_nxt;

//combinational part

 always @* 
	begin 
	//Horizontal and Vertical Total Time
	if (hcount < HOR_TOT_TIME - 1) 
		begin
		hcount_nxt = hcount + 1;
		vcount_nxt = vcount;
		end
	else 
		begin
		hcount_nxt = 0;
		if (vcount < VER_TOT_TIME - 1)
			vcount_nxt = vcount + 1;
		else	
			vcount_nxt = 0;
		end
	//Horizontal synchronization
	if ((hcount >= HOR_SYNC_START - 1) && (hcount < ((HOR_SYNC_START - 1) + HOR_SYNC_TIME))) 
		hsync_nxt = 1;
	else 
		hsync_nxt = 0;
	//Vertical synchronization
	if ((hcount == HOR_TOT_TIME - 1) && (vcount == VER_SYNC_START + VER_SYNC_TIME - 1))
		vsync_nxt = 0;
	else if ((vcount >= VER_SYNC_START) && (vcount <= (VER_SYNC_START + VER_SYNC_TIME - 1))) 
		vsync_nxt = 1;
	else if ((hcount == HOR_TOT_TIME - 1) && (vcount == (VER_SYNC_START - 1)))
		vsync_nxt = 1;

	else
		vsync_nxt = 0;
	// Horizontal blank
	if ((hcount >= HOR_BLNK_START - 1) && (hcount < (HOR_TOT_TIME - 1)))  
		hblnk_nxt = 1;
	else 
		hblnk_nxt = 0;
	//Vertical blank
	if ((hcount == (HOR_TOT_TIME - 1)) && (vcount == VER_TOT_TIME - 1))
		vblnk_nxt = 0;
	else if ((vcount >= VER_BLNK_START - 1) && (vcount <= VER_TOT_TIME - 1) && (hcount == (HOR_TOT_TIME - 1))) 
		vblnk_nxt = 1;
	else if (vcount < VER_BLNK_START - 1)
	   vblnk_nxt = 0;
	else 
		vblnk_nxt = vblnk;
	
end

//sequential part

always @(posedge pclk)
if(rst) begin //synchronic reset
  hcount <= 0;
  vcount <= 0;
  hsync  <= 0;
  vsync  <= 0;
  vblnk  <= 0;
  hblnk  <= 0;
  end
else
  begin
  hcount <= hcount_nxt;
  vcount <= vcount_nxt;
  hsync  <= hsync_nxt;
  vsync  <= vsync_nxt;
  vblnk  <= vblnk_nxt;
  hblnk  <= hblnk_nxt;
  end

endmodule

