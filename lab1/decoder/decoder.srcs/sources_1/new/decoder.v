`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 07:13:00 PM
// Design Name: 
// Module Name: decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module decoder #(parameter WIDTH = 4) (
       input [$clog2(WIDTH) - 1:0] sel,
       output [WIDTH - 1:0] out
    );

    assign out = 1'b1 << sel;

endmodule
