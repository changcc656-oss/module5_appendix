module adder (
    input  [31:0] x,
    input  [31:0] y,
    output [31:0] sum,
    output        Cout
);

    assign {Cout, sum} = x + y;

endmodule
