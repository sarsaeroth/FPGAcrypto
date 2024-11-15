#include "Vrsa_basic.h"  // Verilator generated header for the rsa core
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate rsa core
    Vrsa_basic *rsa = new Vrsa_basic;

    rsa->n = 0x2b7e1516;  // Example key
    rsa->message = 0x6bc1bee2;  // Example plaintext
    rsa->e = 2;
    rsa->clk = 0;

    int cycles = 0;
    int max_cycles = 1000;  //set number of cycles 

    while (!Verilated::gotFinish() && cycles < max_cycles) {
        rsa->clk = !rsa->clk;  // toggle clk
        rsa->eval();     

        if (rsa->cipher != 0) {
            printf("Ciphertext: %x\n", rsa->cipher);
            break;
        }

        cycles++;
    }

    if (cycles >= max_cycles) {
        printf("Did not complete encryption.\n");
    }

    delete rsa;
    return 0;
}