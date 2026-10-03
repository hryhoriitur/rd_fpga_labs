//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2026 09:15:46 PM
// Design Name: 
// Module Name: fifo_axi_streamer
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

module bin2gray #(
    parameter int WIDTH = 16
)
(
    input  logic [WIDTH - 1 : 0] bin,
    output logic [WIDTH - 1 : 0] gray
);
    assign gray = bin ^ (bin >> 1);
endmodule

module gray2bin #(
    parameter int WIDTH = 16
)
(
    input  logic [WIDTH - 1 : 0] gray,
    output logic [WIDTH - 1 : 0] bin
);
    always_comb begin
        bin[WIDTH - 1] = gray[WIDTH - 1];
        for (int i = WIDTH - 2; i >= 0; i--) begin
            bin[i] = bin[i + 1] ^ gray[i];
        end
    end
endmodule

module cdc_sync #(
    parameter int WIDTH = 16
)
(
    input  logic                 clk_b,
    input  logic [WIDTH - 1 : 0] value_a,
    output logic [WIDTH - 1 : 0] value_b
);
    logic [WIDTH - 1 : 0] sync_stage1;
    
    always @(posedge clk_b)
    begin
        sync_stage1 <= value_a;
        value_b <= sync_stage1; 
    end
endmodule

module fifo_axi_streamer #(
    parameter integer
        INPUT_DATA_W       = 8,
        OUTPUT_DATA_W      = 32,
        FIFO_SIZE_OUTPUT_W = 256
)
(
    input   logic                                     clk_in,
    input   logic    [INPUT_DATA_W - 1  : 0]          input_data,
    input   logic                                     clk,
    input   logic                                     rst,
    input   logic                                     fifo_en,

    output  logic    [OUTPUT_DATA_W - 1     : 0]      m_axis_tdata,
    output  logic    [(OUTPUT_DATA_W / 8) - 1 : 0]    m_axis_tkeep,
    output  logic                                     m_axis_tlast,
    output  logic                                     m_axis_tvalid,
    input   logic                                     m_axis_tready
);

    localparam FIFO_ADDR_WIDTH = $clog2(FIFO_SIZE_OUTPUT_W);

    logic [INPUT_DATA_W - 1  : 0] fifo_buff [FIFO_SIZE_OUTPUT_W - 1 : 0];
    // output clock domain
    logic [FIFO_ADDR_WIDTH - 1 : 0] q_head, q_tail_gray_sys, q_tail_sys;
    logic [FIFO_ADDR_WIDTH - 1 : 0] q_size_sys;
    // input clock domain
    logic [FIFO_ADDR_WIDTH - 1 : 0] q_tail, q_tail_gray;
    
    logic fifo_en_in;
    
    assign q_size_sys = (((q_tail_sys - q_head) % FIFO_SIZE_OUTPUT_W) + FIFO_SIZE_OUTPUT_W) % FIFO_SIZE_OUTPUT_W;

    always_ff @(posedge clk or posedge rst)
    begin
        if (rst) begin
            q_head <= 0;
            m_axis_tvalid <= 0;
            m_axis_tdata  <= 0;
        end else if (!m_axis_tvalid || m_axis_tready) begin
            if (q_size_sys >= 4) begin
                m_axis_tdata <= { fifo_buff[q_head],
                                  fifo_buff[(q_head + 1) % FIFO_SIZE_OUTPUT_W],
                                  fifo_buff[(q_head + 2) % FIFO_SIZE_OUTPUT_W],
                                  fifo_buff[(q_head + 3) % FIFO_SIZE_OUTPUT_W]};
                q_head <= q_head + 4;
                m_axis_tvalid <= 1'b1;
            end else
                m_axis_tvalid <= 1'b0;
        end 
    end
    
    assign m_axis_tkeep = '1;
    assign m_axis_tlast = 1'b0;

    always_ff @(posedge clk_in or posedge rst)
    begin
        if (rst) begin
            q_tail <= 0;
        end else
            if (fifo_en_in) begin
                fifo_buff[q_tail % FIFO_SIZE_OUTPUT_W] <= input_data;
                q_tail <= q_tail + 1;
            end
    end
    
    bin2gray #(.WIDTH(FIFO_ADDR_WIDTH)) bin2gray_q_tail (
        .bin(q_tail),
        .gray(q_tail_gray)
    );
    
    cdc_sync #(.WIDTH(FIFO_ADDR_WIDTH)) cdc_in_sys_sync(
        .clk_b(clk),
        .value_a(q_tail_gray),
        .value_b(q_tail_gray_sys)
    );
    
    gray2bin #(.WIDTH(FIFO_ADDR_WIDTH)) gray2bin_q_tail_sys (
        .gray(q_tail_gray_sys),
        .bin(q_tail_sys)
    );
    
    cdc_sync #(.WIDTH(1)) cdc_fifo_in_sync(
        .clk_b(clk_in),
        .value_a(fifo_en),
        .value_b(fifo_en_in)
    );

endmodule
