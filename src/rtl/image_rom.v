//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   image_rom
 Author:        Robert Szczygiel
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: Xilinx recommended + ANSI ports
 Description:  Template for ROM module as recommended by Xilinx

 ** This example shows the use of the Vivado rom_style attribute
 **
 ** Acceptable values are:
 ** block : Instructs the tool to infer RAMB type components.
 ** distributed : Instructs the tool to infer LUT ROMs.
 **
 */
//////////////////////////////////////////////////////////////////////////////
module image_rom (
    input wire clk,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
);


reg [11:0] rom [0:4095];

initial $readmemh("C:/Users/jakub/Documents/UEC/datafiles/kaczka.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule
