// EIE330 Lab 1, Task 2: One-bit Magnitude Comparator
// Synthesizable Verilog (no clock or reset required).
// Board convention: button released=1, pressed=0; LED off=1, on=0.
module one_bit_comparator (
    input  wire B2,      // Button for logical A
    input  wire B3,      // Button for logical B
    output wire led1,    // A < B indicator; active low
    output wire led2,    // A = B indicator; active low
    output wire led3     // A > B indicator; active low
);
    // Translate active-low physical buttons into logical operands.
    wire A, B;
    assign A = ~B2;
    assign B = ~B3;

    // Three mutually exclusive relations for one-bit operands.
    wire less_bit;
    wire equal_bit;
    wire greater_bit;

    assign less_bit    = (~A) & B;
    assign equal_bit   = ~(A ^ B);
    assign greater_bit = A & (~B);

    // Required order: LED1=LT, LED2=EQ, LED3=GT.
    assign led1 = ~less_bit;
    assign led2 = ~equal_bit;
    assign led3 = ~greater_bit;
endmodule
