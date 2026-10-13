# Run at the repository root. Requires iverilog and vvp.
.PHONY: all full-adder comparator clean
all: full-adder comparator
results:
	mkdir -p results
full-adder: | results
	iverilog -g2012 -Wall -s full_adder_tb -o results/full_adder_tb.out RTL/full_adder/full_adder.v sim/full_adder_tb.v
	vvp results/full_adder_tb.out
comparator: | results
	iverilog -g2012 -Wall -s one_bit_comparator_tb -o results/one_bit_comparator_tb.out RTL/one_bit_comparator/one_bit_comparator.v sim/one_bit_comparator_tb.v
	vvp results/one_bit_comparator_tb.out
clean:
	rm -f results/*.out results/*.vcd results/*.csv
