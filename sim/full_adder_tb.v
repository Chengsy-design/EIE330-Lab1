`timescale 1ns / 1ns
// Exhaustive pin-level functional test (8 cases, 20 ns per case).
module full_adder_tb;
    reg B2, B3, B4;
    wire led1, led2;

    full_adder dut (
        .B2(B2), .B3(B3), .B4(B4),
        .led1(led1), .led2(led2)
    );

    reg A, B, Cin;
    reg [1:0] expected_total; // Width 2 retains carry (0 through 3).
    reg expected_led1, expected_led2;
    integer i, errors, csv_fd;

    initial begin
        $dumpfile("results/full_adder.vcd");
        $dumpvars(0, full_adder_tb);
        csv_fd = $fopen("results/full_adder.csv", "w");
        if (csv_fd == 0) $fatal(1, "Cannot open results/full_adder.csv");
        $fdisplay(csv_fd,
            "time_ns,case,A,B,Cin,B2,B3,B4,expected_led1,expected_led2,actual_led1,actual_led2,status");
        errors = 0;
        B2 = 1'b1; B3 = 1'b1; B4 = 1'b1;

        for (i = 0; i < 8; i = i + 1) begin
            // FA0=000 ... FA7=111 (logical input order A,B,Cin).
            A = i[2]; B = i[1]; Cin = i[0];
            B2 = ~A; B3 = ~B; B4 = ~Cin;

            // Independent arithmetic oracle; never reuse DUT carry logic.
            expected_total = {1'b0, A} + {1'b0, B} + {1'b0, Cin};
            expected_led1 = ~expected_total[0];
            expected_led2 = ~expected_total[1];

            #1; // Wait for combinational assignments to settle.
            if ({led1, led2} !== {expected_led1, expected_led2}) begin
                errors = errors + 1;
                $display("FA%0d FAIL: A B Cin=%b%b%b expected=%b%b actual=%b%b",
                    i, A, B, Cin, expected_led1, expected_led2, led1, led2);
                $fdisplay(csv_fd,
                    "%0t,FA%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,FAIL",
                    $time, i, A, B, Cin, B2, B3, B4,
                    expected_led1, expected_led2, led1, led2);
            end else begin
                $display("FA%0d PASS: A B Cin=%b%b%b LED pins=%b%b",
                    i, A, B, Cin, led1, led2);
                $fdisplay(csv_fd,
                    "%0t,FA%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,PASS",
                    $time, i, A, B, Cin, B2, B3, B4,
                    expected_led1, expected_led2, led1, led2);
            end
            #19; // Total 20 ns per input combination.
        end

        $fclose(csv_fd);
        if (errors != 0) $fatal(1, "Full adder: %0d mismatches", errors);
        $display("FULL ADDER: PASS (8/8 cases)");
        $finish;
    end
endmodule
