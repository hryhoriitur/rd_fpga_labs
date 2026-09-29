`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2026 07:35:30 PM
// Design Name: 
// Module Name: tb_microblaze
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


module tb_microblaze;

    reg clk;
    reg rst;
    
    localparam LEDS_NUM = 4;
    
    tri [LEDS_NUM - 1:0] leds_bidir;
    wire [LEDS_NUM - 1:0] leds;
    assign leds_bidir = leds;
    
    tri dir_switch_bidir;
    reg dir_switch;
    assign dir_switch_bidir = dir_switch;
    
    tri pause_button_bidir;
    reg pause_button;
    assign pause_button_bidir = pause_button;
    
    mb_led_gpio_wrapper mb(
        .clk_100MHz(clk),
        .gpio_rtl_dir_sw_tri_io(dir_switch_bidir),
        .gpio_rtl_leds_tri_io(leds_bidir),
        .gpio_rtl_pause_btn_tri_io(pause_button_bidir),
        .reset_rtl_0(rst)
    );

    localparam CLOCK_HALF_PERIOD = 5;
    localparam CLOCK_PERIOD = 2 * CLOCK_HALF_PERIOD;
    
    localparam CPU_DELAY = 200;
    localparam TIMER_DELAY = 323000;
    
    localparam MAX_LEDS_VALUE = 16;

    initial clk = 0;
    always #CLOCK_HALF_PERIOD clk = ~clk;
    
    task automatic check_leds(input int expected,
                              input [LEDS_NUM - 1 : 0] actual);
        if (expected === actual)
            $display("PASS: expected digit %d matches", expected);
        else
            $display("FAIL: expected digit %d != actual %d", expected, actual);            
    endtask
    
    initial begin
        integer i;
        integer paused_num;

        dir_switch = 1;

        rst = 1;
        @(posedge clk); #1;
        rst = 0;
        @(negedge clk); #1;
        rst = 1;
        
        pause_button = 0;
        
        #50000;
        
        for (i = 0; i < MAX_LEDS_VALUE; i = i + 1) begin
            @(negedge clk); #1;
            
            check_leds(i, leds_bidir);
            
            #TIMER_DELAY;
            #CPU_DELAY;
        end
        
        dir_switch = 0;
        @(posedge clk); #1;
        rst = 0;
        #500
        @(negedge clk); #1;
        rst = 1;
 
        #50000;
        
        #TIMER_DELAY;
        #CPU_DELAY;
        
        for (i = MAX_LEDS_VALUE - 1; i > 0; i = i - 1) begin
            @(negedge clk); #1;
            
            check_leds(i, leds_bidir);
            
            #TIMER_DELAY;
            #CPU_DELAY;
        end
        
        paused_num = leds_bidir;
        
        pause_button = 1;
        #50000;
        pause_button = 0;
        
        #TIMER_DELAY;
        #CPU_DELAY;
        
        if (leds_bidir === paused_num)
            $display("PASS: value is unchanged during pause");
        else
            $display("FAIL: value changed during pause: expected %d, got %d", paused_num, leds_bidir);
            
        pause_button = 1;
        #50000;
        pause_button = 0;
        
        #TIMER_DELAY;
        #CPU_DELAY;
        
        if (leds_bidir != paused_num)
            $display("PASS: value is unchanged after pause");
        else
            $display("FAIL: value unchanged after pause: expected %d, got %d", paused_num, leds_bidir);
        
    end
endmodule
