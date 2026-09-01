`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 07:44:12 PM
// Design Name: 
// Module Name: decoder_tb
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

module decoder_tb;

    localparam NUM_INSTANCES = 2;
    localparam int WIDTH_ARRAY [0 : NUM_INSTANCES - 1] = '{4, 8};

    genvar i;
    generate

        for (i = 0; i < NUM_INSTANCES; i = i + 1) begin

            reg  [$clog2(WIDTH_ARRAY[i]) - 1 : 0] sel_value;
            wire [WIDTH_ARRAY[i] - 1 : 0] out_value;

            decoder #(.WIDTH(WIDTH_ARRAY[i])) decoder_test (
                .sel(sel_value),
                .out(out_value)
            );

            initial begin
                sel_value = 0;
                #1
                $display("[Decoder %d] WIDTH = %d, IN = %h, OUT = %h", i, WIDTH_ARRAY[i], sel_value, out_value);
                #200;
                sel_value = 7;
                #1
                $display("[Decoder %d] WIDTH = %d, IN = %h, OUT = %h", i, WIDTH_ARRAY[i], sel_value, out_value);
            end
        end
    endgenerate

endmodule
