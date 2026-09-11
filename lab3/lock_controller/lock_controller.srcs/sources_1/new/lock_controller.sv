`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2026 07:35:33 PM
// Design Name: 
// Module Name: lock_controller
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

package lock_pkg;
    typedef enum logic [1:0] {
        LOCKED,
        WAIT_D2,
        WAIT_D3,
        UNLOCKED
    } state_t;
endpackage

module debounce_filter #(parameter COUNT_MAX = 200_000, parameter BITS_PER_DIGIT = 4) (
    input logic clk,
    input logic [BITS_PER_DIGIT - 1:0] digit_raw,
    output logic [BITS_PER_DIGIT - 1:0] digit_clean,
    output logic digit_ready
);
    logic [17:0] counter;
    
    always_ff @(posedge clk) begin
        if (digit_raw !== digit_clean) begin
            counter <= counter + 1;
            digit_ready <= 0;
            if (counter == COUNT_MAX) begin
                counter <= 0;
                digit_clean <= digit_raw;
                digit_ready <= 1;
            end
        end else begin 
            counter <= 0;
            digit_ready <= 0;
        end
    end
endmodule

module lock_controller
#(parameter logic [3:0] SECRET_CODE [0:2] = '{4'd7, 4'd3, 4'd1}) 
    (
        input logic clk,
        input logic rst,
        input logic [3:0] digit_in,
        input logic digit_valid,
        output logic unlocked_led
    );
    
    import lock_pkg::*;
    state_t state, next_state;

    always_ff @(posedge clk or posedge rst)
        state <= rst ? LOCKED : next_state;

    always_comb begin
        next_state = state;
        if (digit_valid)
            case (state)
                LOCKED: next_state = (digit_in === SECRET_CODE[0]) ? WAIT_D2  : LOCKED;
                WAIT_D2:  next_state = (digit_in === SECRET_CODE[1]) ? WAIT_D3  : LOCKED;
                WAIT_D3:  next_state = (digit_in === SECRET_CODE[2]) ? UNLOCKED : LOCKED;
                UNLOCKED: next_state = UNLOCKED;
            endcase
    end

    always_comb begin
        unlocked_led = (state == UNLOCKED);
    end
endmodule

module lock_controller_debounced
#(parameter logic [3:0] SECRET_CODE [0:2] = '{4'd7, 4'd3, 4'd1})
    (
        input logic clk,
        input logic rst,
        input logic [3:0] digit_in,
        output logic unlocked_led
    );
    
    logic [3:0] digit_clean;
    logic digit_ready;
    
    debounce_filter #(.COUNT_MAX(5), .BITS_PER_DIGIT(4)) lock_input_debouncer(
        .clk(clk),
        .digit_raw(digit_in),
        .digit_clean(digit_clean),
        .digit_ready(digit_ready)
    );
    
    lock_controller #(
        .SECRET_CODE(SECRET_CODE)
    ) lock_controller (
        .clk(clk),
        .rst(rst),
        .digit_in(digit_clean),
        .digit_valid(digit_ready),
        .unlocked_led(unlocked_led)
    );    

endmodule
