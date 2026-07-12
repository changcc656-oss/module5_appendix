module comb_multiplier (
    input         clk,
    input         reset,
    input  [31:0] A,
    input  [31:0] B,
    output reg [63:0] P
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            P <= 64'b0;
        end else begin
            P <= A * B;
        end
    end

endmodule
