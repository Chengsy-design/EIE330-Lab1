// EIE330 Lab 1, Task 1: Full Adder
// Synthesizable Verilog (no clock or reset required).
// Board convention: button released=1, pressed=0; LED off=1, on=0.
module full_adder (
    input  wire B2,      // Button for logical A
    input  wire B3,      // Button for logical B
    input  wire B4,      // Button for logical carry-in Cin
    output wire led1,    // Sum indicator; active low
    output wire led2     // Carry-out indicator; active low
);
    // Translate active-low physical buttons into active-high operands.
    wire A, B, Cin;
    assign A   = ~B2;
    assign B   = ~B3;
    assign Cin = ~B4;

    // Two-half-adder implementation of the full-adder equations.
    wire propagate_bit;
    wire sum_bit;
    wire carry_bit;

    assign propagate_bit = A ^ B;
    assign sum_bit       = propagate_bit ^ Cin;
    assign carry_bit     = (A & B) | (propagate_bit & Cin);

    // Translate the logical results into active-low LED outputs.
    assign led1 = ~sum_bit;
    assign led2 = ~carry_bit;
endmodule
