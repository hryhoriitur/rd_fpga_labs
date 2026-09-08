`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2026 06:33:18 PM
// Design Name: 
// Module Name: tb_counter
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

module tb_counter;
    reg clk;
    reg rst;
    reg load;
    reg [3:0] data_in;
    reg en;
    reg up_down;
    wire [3:0] count;

    counter counter_test (
        .clk(clk),
        .rst(rst),
        .load(load),
        .data_in(data_in),
        .en(en),
        .up_down(up_down),
        .count(count)
    );

    localparam CLOCK_HALF_PERIOD = 25;
    localparam CLOCK_PERIOD = 2 * CLOCK_HALF_PERIOD;
    localparam NUM_TEST_CYCLES = 3;
    localparam NUM_REPEATED_TESTS = 2;
    localparam INITIAL_COUNTER_VALUE = 4'd10;
    localparam UPDATED_COUNTER_VALUE = 4'd5;
    localparam MAX_COUNTER_VALUE = 16;

    initial clk = 0;
    always #CLOCK_HALF_PERIOD clk = ~clk;

    integer i;
    integer j;
    integer expected;

    task automatic check_counter(
        input [3:0] expected,
        input string name
    );
        if (count === expected)
            $display("PASS: %s", name);
        else
            $display("FAIL: %s, expected=%d, actual=%d", name, expected, count);
    endtask

    initial begin

        rst = 0;
        #CLOCK_HALF_PERIOD;
        // до цього моменту значення count знаходиться в неініціалізованому X стані,
        // оскільки у відповідний регістр ще не було жодного запису 
        rst = 1;
        #CLOCK_PERIOD;
        rst = 0;

        load = 1;
        data_in = INITIAL_COUNTER_VALUE;
        @(posedge clk); #1;
        load = 0;

        en = 1;
        up_down = 1;

        for (j = 0; j < NUM_REPEATED_TESTS; j = j + 1) begin
            for (i = 0; i < NUM_TEST_CYCLES; i = i + 1)
                @(posedge clk); #1;
            
            expected = (INITIAL_COUNTER_VALUE + (j + 1) * NUM_TEST_CYCLES) % MAX_COUNTER_VALUE;
            check_counter(expected, "Check counter after 3 clock cycles");
        end

        en = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;

        check_counter(expected, "Check counter unmodified after 2 clock cycles with en=0");

        en = 1;
        up_down = 0;
        @(posedge clk); #1;

        expected = (((expected - 1) % MAX_COUNTER_VALUE) + MAX_COUNTER_VALUE) % MAX_COUNTER_VALUE;
        check_counter(expected, "Check counter backward wrap");

        load = 1;
        data_in = UPDATED_COUNTER_VALUE;

        en = 1;
        up_down = 1;
        @(posedge clk); #1;

        expected = UPDATED_COUNTER_VALUE;
        check_counter(expected, "Check counter load vs en");

        load = 0;
        up_down = 0;
        @(posedge clk); #1;

        expected = expected - 1;
        check_counter(expected, "Check counter decrement");

        $display("All tests completed successfully.");
        $finish;
    end
endmodule
