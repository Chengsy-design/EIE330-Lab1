`timescale 1ns / 1ns
// Exhaustive pin-level functional test (4 cases, 20 ns per case).
module one_bit_comparator_tb;
    reg B2, B3;
    wire led1, led2, led3;

    one_bit_comparator dut (
        .B2(B2), .B3(B3),
        .led1(led1), .led2(led2), .led3(led3)
    );

    reg A, B;
    reg expected_lt, expected_eq, expected_gt;
    reg expected_led1, expected_led2, expected_led3;
    integer i, errors, csv_fd;

    initial begin
        $dumpfile("results/one_bit_comparator.vcd");
        $dumpvars(0, one_bit_comparator_tb);
        csv_fd = $fopen("results/one_bit_comparator.csv", "w");
        if (csv_fd == 0)
            $fatal(1, "Cannot open results/one_bit_comparator.csv");
        $fdisplay(csv_fd,
            "time_ns,case,A,B,B2,B3,expected_led1,expected_led2,expected_led3,actual_led1,actual_led2,actual_led3,status");
        errors = 0;
        B2 = 1'b1; B3 = 1'b1;

        for (i = 0; i < 4; i = i + 1) begin
            // CP0=00, CP1=01, CP2=10, CP3=11 (logical A,B).
            A = i[1]; B = i[0];
            B2 = ~A; B3 = ~B;

            // Independent relational-operator oracle.
            expected_lt = (A < B);
            expected_eq = (A == B);
            expected_gt = (A > B);
            expected_led1 = ~expected_lt;
            expected_led2 = ~expected_eq;
            expected_led3 = ~expected_gt;

            #1;
            if ({led1, led2, led3} !==
                {expected_led1, expected_led2, expected_led3}) begin
                errors = errors + 1;
                $display("CP%0d FAIL: A B=%b%b expected=%b%b%b actual=%b%b%b",
                    i, A, B, expected_led1, expected_led2, expected_led3,
                    led1, led2, led3);
                $fdisplay(csv_fd,
                    "%0t,CP%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,FAIL",
                    $time, i, A, B, B2, B3,
                    expected_led1, expected_led2, expected_led3,
                    led1, led2, led3);
            end else begin
                $display("CP%0d PASS: A B=%b%b LED pins=%b%b%b",
                    i, A, B, led1, led2, led3);
                $fdisplay(csv_fd,
                    "%0t,CP%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,PASS",
                    $time, i, A, B, B2, B3,
                    expected_led1, expected_led2, expected_led3,
                    led1, led2, led3);
            end
            #19;
        end

        $fclose(csv_fd);
        if (errors != 0) $fatal(1, "Comparator: %0d mismatches", errors);
        $display("ONE-BIT COMPARATOR: PASS (4/4 cases)");
        $finish;
    end
endmodule
