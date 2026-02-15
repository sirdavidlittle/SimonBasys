# project SIMON
> An implementation of Milton-Bradley’s SIMON game in Verilog for Basys3 FPGA hardware.
---

# Why?

SIMON is an icon of 1980's handheld games, and just so happens to be the perfect project for learning FPGA. It features debouncing user input, asynchronous and synchronous signals, LFSRs, timers, LCD screens, and state machines!

# How?

The Simon derives it's inputs from 4 colored buttons and a reset switch, and writes text output to an LCD, instructing the user what do to next. Randomization of the colors is accomplished through a continuously running LFSR from which random data is sampled. Game logic is produced by a Mealy state machine (with some Moore states).

Game development is quite difficult without high level paradigms such as function invocation, RAM, the call stack, CPUs, or debuggers like GDB. This was very rewarding (yet frustrating) challenge and gave me great insights into developing applications in FPGA.

Thanks to [FPGA student](https://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html) for Basys hardware tutorials.
I used Vivado 2025.1 for this project.
