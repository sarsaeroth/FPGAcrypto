#include "Vexample.h"       // Include the Verilated model
#include "verilated.h"      // Include Verilator headers
#include <iostream>
#include <chrono>

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    Vexample* top = new Vexample;

    auto start = std::chrono::high_resolution_clock::now();

    while (!Verilated::gotFinish()) {
        top->eval();
    }

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end - start;
    std::cout << "Simulation time: " << elapsed.count() << " seconds" << std::endl;

    delete top;
    return 0;
}
