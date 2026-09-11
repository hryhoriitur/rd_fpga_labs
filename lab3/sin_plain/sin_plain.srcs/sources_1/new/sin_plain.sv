`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2026 03:32:07 PM
// Design Name: 
// Module Name: sin_plain
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


module sin_plain #(parameter WIDTH = 8) (
    input logic clk,
    input logic rst,
    input logic [WIDTH - 1 : 0] x,
    output reg [WIDTH - 1 : 0] sin
);

    reg [WIDTH - 1 : 0] x_reg, x_sq_reg;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            x_reg <= 0;
            x_sq_reg <= 0;
        end else begin
            x_reg <= x;
            x_sq_reg <= x * x;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            sin <= 0;
        else
            sin <= 1 - x_sq_reg / 2 + (x_sq_reg * x_sq_reg) / 24 - (x_sq_reg * x_sq_reg * x_sq_reg * x_sq_reg) / 720;
    end
    
endmodule
