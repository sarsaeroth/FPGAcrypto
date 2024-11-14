#include "Vrsa_basic.h"  // Verilator generated header for the rsa core
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate rsa core
    Vrsa_basic *rsa = new Vrsa_basic;

    // Apply inputs to the rsa core
    rsa->n = 0x2b7e1516;  // Example key
    rsa->message = 0x6b;  // Example plaintext
    rsa->e = 65537;
    rsa->clk = 0;

    int cycles = 0;
    int max_cycles = 1000;  // Set a maximum cycle count to avoid infinite loops

    while (!Verilated::gotFinish() && cycles < max_cycles) {
        rsa->clk = !rsa->clk;  // Toggle clock
        rsa->eval();           // Evaluate the core

        // Check if output is ready
        if (rsa->cipher != 0) {
            printf("Ciphertext: %x\n", rsa->cipher);
            break;
        }

        cycles++;
    }

    if (cycles >= max_cycles) {
        printf("Reached max cycles without completing.\n");
    }

    delete rsa;
    return 0;
}

