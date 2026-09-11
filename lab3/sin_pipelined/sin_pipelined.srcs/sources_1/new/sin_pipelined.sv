module sin_pipelined #(parameter WIDTH = 8) (
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
    
    reg [WIDTH - 1 : 0] sin_pt1, x_sq_reg_pt1;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sin_pt1 <= 0;
            x_sq_reg_pt1 <= 0;
        end else begin
            sin_pt1 <= (x_sq_reg * x_sq_reg * x_sq_reg * x_sq_reg);
            x_sq_reg_pt1 <= x_sq_reg;
        end
    end
    
    reg [WIDTH - 1 : 0] sin_pt2, x_sq_reg_pt2;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sin_pt2 <= 0;
            x_sq_reg_pt2 <= 0;
        end else begin
            sin_pt2 <= sin_pt1 / 30 - (x_sq_reg_pt1 * x_sq_reg_pt1);
            x_sq_reg_pt2 <= x_sq_reg_pt1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            sin <= 0;
        else
            sin <= 1 - x_sq_reg_pt2 / 2 - sin_pt2 / 24;
    end

endmodule
