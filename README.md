# EIE330 Lab 1 — Verilog source

Contains synthesizable, combinational RTL and exhaustive pin-level testbenches for the **full adder** (8 vectors) and **one-bit comparator** (4 vectors).

- `RTL/full_adder/full_adder.v`: top module `full_adder`.
- `RTL/one_bit_comparator/one_bit_comparator.v`: top module `one_bit_comparator`.
- `sim/*.v`: self-checking Icarus Verilog testbenches, with VCD and CSV output.
- `results/`: generated files, not committed by default.

All push buttons and LEDs use **active-low electrical levels**; the module translates them to logical positive-polarity functions and back.

To run on Ubuntu (after installing Icarus Verilog):

```sh
make all
```

Expected final messages are `FULL ADDER: PASS (8/8 cases)` and `ONE-BIT COMPARATOR: PASS (4/4 cases)`.

Use **one RTL top module at a time** in the board simulator; testbenches must not be synthesized. For a dependency-free check of the RTL Boolean assignments, run `python3 scripts_verify.py` (this is not an HDL simulation). See `README_CN.md` for pin mapping, anticipated board behavior and report/GitHub steps.
