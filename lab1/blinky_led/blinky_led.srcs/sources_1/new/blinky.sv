`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 10:47:27 PM
// Design Name: 
// Module Name: blinky
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


module blinky #(parameter CLK_FREQ_HZ = 100_000_000)
    (
        input logic clk,
        input logic rst,
        output logic [3 : 0] leds
    );
    
    reg [$clog2(CLK_FREQ_HZ) : 0] counter;
    
    always_ff @(posedge clk or negedge rst)
    begin
        if (~rst)
            begin
                counter <= 0;
                leds <= 0;
            end
        else
            begin
                if (counter == CLK_FREQ_HZ)
                    begin
                        leds <= leds + 1;
                        counter <= 0;
                    end
                else
                    begin
                        counter <= counter + 1;
                    end
            end
    end
endmodule
