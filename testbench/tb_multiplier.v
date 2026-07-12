module tb_multiplier;

    reg         clk;
    reg         reset;
    reg         start;
    reg  [31:0] A;
    reg  [31:0] B;

    wire [63:0] P_comb;
    wire [63:0] P_seq;
    wire        done;

    reg  [63:0] expected;

    comb_multiplier u_comb (
    .clk   (clk),
    .reset (reset),
    .A     (A),
    .B     (B),
    .P     (P_comb)
);

    seq_multiplier u_seq (
        .clk   (clk),
        .reset (reset),
        .start (start),
        .A     (A),
        .B     (B),
        .P     (P_seq),
        .done  (done)
    );

    always #5 clk = ~clk;

    task run_test;
        input [31:0] test_A;
        input [31:0] test_B;
        begin
            A = test_A;
            B = test_B;
            expected = test_A * test_B;

            start = 1'b1;
            #10;
            start = 1'b0;

            wait(done == 1'b1);
            #10;

            if (P_comb !== expected) begin
                $display("COMB FAIL: A=%d B=%d P_comb=%d expected=%d",
                         test_A, test_B, P_comb, expected);
            end else begin
                $display("COMB PASS: A=%d B=%d P_comb=%d",
                         test_A, test_B, P_comb);
            end

            if (P_seq !== expected) begin
                $display("SEQ FAIL : A=%d B=%d P_seq=%d expected=%d",
                         test_A, test_B, P_seq, expected);
            end else begin
                $display("SEQ PASS : A=%d B=%d P_seq=%d",
                         test_A, test_B, P_seq);
            end

            #20;
        end
    endtask

    initial begin
	$vcdplusfile("multiplier.vpd");
	$vcdpluson(0, tb_multiplier);

        clk   = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        A     = 32'b0;
        B     = 32'b0;

        #20;
        reset = 1'b0;

        run_test(32'd5,          32'd3);
        run_test(32'd10,         32'd20);
        run_test(32'd1234,       32'd5678);
        run_test(32'h0000FFFF,   32'd2);
        run_test(32'hFFFFFFFF,   32'd1);
        run_test(32'h00010000,   32'h00010000);

        $display("All tests completed.");
        $finish;
    end

endmodule
