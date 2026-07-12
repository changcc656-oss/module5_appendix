module seq_multiplier (
    input         clk,
    input         reset,
    input         start,
    input  [31:0] A,
    input  [31:0] B,
    output reg [63:0] P,
    output reg    done
);

    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0]  state;
    reg [31:0] multiplicand;
    reg [63:0] product;
    reg [5:0]  count;

    wire [31:0] adder_sum;
    wire        adder_cout;
    wire [63:0] next_product;

    adder u_adder (
        .x    (product[63:32]),
        .y    (multiplicand),
        .sum  (adder_sum),
        .Cout (adder_cout)
    );

    assign next_product = product[0] ?
                          {adder_cout, adder_sum, product[31:1]} :
                          {1'b0, product[63:1]};

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= IDLE;
            multiplicand <= 32'b0;
            product      <= 64'b0;
            count        <= 6'b0;
            P            <= 64'b0;
            done         <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;

                    if (start) begin
                        multiplicand <= A;
                        product      <= {32'b0, B};
                        count        <= 6'd0;
                        state        <= RUN;
                    end
                end

                RUN: begin
                    product <= next_product;
                    count   <= count + 6'd1;

                    if (count == 6'd31) begin
                        P     <= next_product;
                        done  <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    done <= 1'b1;

                    if (start) begin
                        multiplicand <= A;
                        product      <= {32'b0, B};
                        count        <= 6'd0;
                        done         <= 1'b0;
                        state        <= RUN;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
