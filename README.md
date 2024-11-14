# FPGAcrypto
FPGAcrypto is a collection of scripts for testing secure computation of cryptographic algorithms on FPGA accelerators by generating Verilog code which is converted to C++ and compiled to binary format using Verilator, and then benchmarked using gem5. This repository was created as part of a term project for CPRE 5810, Computer Hardware Architecture, at Iowa State University.

## Designs
This subdirectory features a collection of Verilog scripts corresponding to various cryptographic design implementations, as well as an basic example script at `example.v`. These scripts are converted to C++ by Verilator.

## Testbench
This subdirectory features a collection of testbenches which can be used for contextualizing the Verilog scripts, including an example at `example_tb.cpp`. These scripts are interpreted by Verilator at compile time.


## Running
This configuration assumes that you have Verilator installed somewhere on PATH. This can be done with an appropriate package manager, such as `sudo apt install verilator`, though you can also clone the repository and compile from source yourself. Once you have done this, you can compile the Verilog script/C++ testbench using `verilator --cc ./designs/<script>.v --exe ./testbenches/<testbench>.cpp`. It can then be compiled with `make -j -C ./obj\_dir/ -f V<script>.mk V<script>`. The compiled binary can then be run with `./obj\_dir/V<script>` or used as a workload in an appropriate gem5 configuration with `/path/to/gem5/build/.../gem5.opt /path/to/gem5/configs/.../config.py ./obj_dir/V<script>`. Note that gem5 functionality requires having previously built a gem5 config with `scons /path/to/gem5/build/../gem5.opt -j nproc`
