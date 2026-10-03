`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 08:23:15 PM
// Design Name: 
// Module Name: tb_mb_dma_btn
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


module tb_mb_dma_btn(

    );
    
    localparam DATA_IN_WIDTH = 8;
    localparam FRAME_SIZE = 320 * 200;
    localparam FRAME_PIXEL_SIZE = 4;
    localparam FRAME_SIZE_B = FRAME_SIZE * FRAME_PIXEL_SIZE;

    logic clk;
    logic rst;
    
    logic clk_in;
    logic [DATA_IN_WIDTH - 1 : 0] data_in;
    
    logic start_btn;

    mb_dma_btn_wrapper mb (
        .clk_100MHz(clk),
        .clk_in_0(clk_in),
        .gpio_btn_tri_i(start_btn),
        .input_data_0(data_in),
        .reset_rtl_0(rst));

    localparam CLOCK_HALF_PERIOD = 6;
    initial clk = 0;
    always #CLOCK_HALF_PERIOD clk = ~clk;
    
    localparam CLOCK_IN_HALF_PERIOD = 3.7 * CLOCK_HALF_PERIOD;
    initial clk_in = 0;
    always #CLOCK_IN_HALF_PERIOD clk_in = ~clk_in;
    
    initial data_in = 0;
    always @(posedge clk_in) begin
        if (!rst)
            data_in <= 0;
        else
            data_in <= data_in + 1'b1;
    end

    initial begin    
        start_btn = 0;
        
        $display("[%0t ns] Starting simulation...", $time);
    
        rst = 1;
        @(posedge clk); #1;
        rst = 0;
        @(negedge clk); #1;
        rst = 1;

        #100000;
        $display("[%0t ns] Pressing start button...", $time);
        start_btn = 1;
        
        #120000;

        start_btn = 0;
    end

endmodule
