`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2026 05:04:48 PM
// Design Name: 
// Module Name: fifo_axi_streamer_top
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

module fifo_axi_streamer_top #(
    parameter integer INPUT_DATA_W       = 8,
    parameter integer OUTPUT_DATA_W      = 32,
    parameter integer FIFO_SIZE_OUTPUT_W = 64
)
(
    input  wire                           clk_in,
    input  wire [INPUT_DATA_W - 1 : 0]    input_data,
    input  wire                           clk,
    input  wire                           rst,
    input  wire                           fifo_en,

    output wire [OUTPUT_DATA_W - 1 : 0]   m_axis_tdata,
    output wire [(OUTPUT_DATA_W/8) - 1:0] m_axis_tkeep,
    output wire                           m_axis_tlast,
    output wire                           m_axis_tvalid,
    input  wire                           m_axis_tready
);

    // Instantiate your SystemVerilog module
    fifo_axi_streamer #(
        .INPUT_DATA_W(INPUT_DATA_W),
        .OUTPUT_DATA_W(OUTPUT_DATA_W),
        .FIFO_SIZE_OUTPUT_W(FIFO_SIZE_OUTPUT_W)
    ) streamer_inst (
        .clk_in(clk_in),
        .input_data(input_data),
        .clk(clk),
        .rst(rst),
        .fifo_en(fifo_en),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tkeep(m_axis_tkeep),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready)
    );

endmodule