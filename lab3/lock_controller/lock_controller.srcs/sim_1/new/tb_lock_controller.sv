`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2026 08:16:55 PM
// Design Name: 
// Module Name: tb_lock_controller
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

import lock_pkg::*;

module tb_lock_controller;

    logic clk;
    logic rst;
    logic [3:0] digit_in;
    logic unlocked_led;
    
    localparam TEST_SEQUENCES_NUM = 4;
    localparam DIGITS_PER_CODE = 3;
    localparam BITS_PER_DIGIT = 4;
    localparam [BITS_PER_DIGIT - 1:0] SECRET_CODE [0:DIGITS_PER_CODE - 1] = '{7, 3, 4};

    logic [BITS_PER_DIGIT - 1:0] test_vectors [0:TEST_SEQUENCES_NUM - 1][0:DIGITS_PER_CODE - 1] = '{
        '{1, 5, 2},
        SECRET_CODE,
        '{3, 6, 9},
        '{1, 3, 7}
    };

    lock_controller_debounced #(
        .SECRET_CODE(SECRET_CODE)
    ) lc (
        .clk(clk),
        .rst(rst),
        .digit_in(digit_in),
        .unlocked_led(unlocked_led)
    );

    state_t SUCCESS_STATES_CHAIN [0:2] = '{
        state_t'(1),
        state_t'(2),
        state_t'(3)
    };
    
    task automatic check_state(input int digits_received,
                               input state_t expected_state,
                               input state_t actual_state);
        if (actual_state === expected_state)
            $display("PASS: input digit num %d -> %s", digits_received, actual_state.name());
        else
            $display("FAIL: input digit num %d -> expected %s, actual %s",
                     digits_received, expected_state.name(), actual_state.name());
                               
    endtask
                               

    localparam CLOCK_HALF_PERIOD = 25;
    localparam CLOCK_PERIOD = 2 * CLOCK_HALF_PERIOD;
    localparam INTERDIGIT_DELAY = CLOCK_PERIOD * 10;

    initial clk = 0;
    always #CLOCK_HALF_PERIOD clk = ~clk;

    initial begin
        integer i;

        for (i = 0; i < TEST_SEQUENCES_NUM; i = i + 1) begin
            integer j;
            logic expected;
                
            rst = 0;
            @(posedge clk); #1;
            rst = 1;
            @(negedge clk); #1;
            rst = 0;
            
            expected = (test_vectors[i] == SECRET_CODE) ? 1 : 0;
            
            if (expected)
                check_state(0, lc.lock_controller.LOCKED, lc.lock_controller.state);
            
            
            for (j = 0; j < DIGITS_PER_CODE; j = j + 1) begin
                state_t expected_state;
            
                @(negedge clk); #1;
                digit_in = test_vectors[i][j];
                #INTERDIGIT_DELAY;
                
                if (expected) begin 
                    expected_state = SUCCESS_STATES_CHAIN[j];
                    check_state(j + 1, expected_state, lc.lock_controller.state);
                end
            end
            
            @(posedge clk); #1;
            if (unlocked_led == expected)
                $display("PASS: test %d: unlocked_led %d == expected %d", i, unlocked_led, expected);
            else
                $display("FAIL: test %d: code %p, unlocked_led %d != expected %d", i, test_vectors[i], unlocked_led, expected);
        end      
    end

endmodule
