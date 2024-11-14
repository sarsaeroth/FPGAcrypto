#include "Vexample.h"       // Include the Verilated model
#include "verilated.h"      // Include Verilator headers
#include <iostream>
#include <chrono>

int main(int argc, char **argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);

    // Instantiate the top module
    Vexample* top = new Vexample;

    // Optional: Use a high-resolution timer to track execution time
    auto start = std::chrono::high_resolution_clock::now();

    // Run simulation until the end condition is met
    while (!Verilated::gotFinish()) {
        top->eval();  // Evaluate the model
    }

    // Measure elapsed time
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end - start;
    std::cout << "Simulation time: " << elapsed.count() << " seconds" << std::endl;

    // Clean up and exit
    delete top;
    return 0;
}
