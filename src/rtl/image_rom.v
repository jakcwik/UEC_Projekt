//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   image_rom
 Author:        Robert Szczygiel
 Version:       1.0
 Last modified: 2017-04-03
 Coding style: Xilinx recommended + ANSI ports
 Description:  This module stores relative path to Duck picture.
 */
//////////////////////////////////////////////////////////////////////////////
module image_rom (
    input wire clk,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
);


reg [11:0] rom [0:4095];

initial $readmemh("./kaczka.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule
