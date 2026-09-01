`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 08:51:51 PM
// Design Name: 
// Module Name: latch
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


module latch (
        input logic [1:0] sel,
        input logic [3:0] in_values,
        output logic out_value
    );

    always_comb begin
        case (sel)
            2'b00: begin
                out_value = in_values[0];
            end
            2'b01: begin
                out_value = in_values[1];
            end
            2'b10: begin
                out_value = in_values[2];
            end
// uncomment to fix latch
            2'b11: begin
                out_value = in_values[3];
            end
        endcase
    end
endmodule
