#include "Vrsa_basic.h" 
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    Vrsa_basic *rsa = new Vrsa_basic;

    rsa->n = 0x2b7e1516;  // Example key
    rsa->message = 0x6bc1bee2;  // Example plaintext
    rsa->e = 2;
    rsa->clk = 0;

    printf("n: %x, message: %x, e: %x\n", rsa->n, rsa->message, rsa->e);

    int cycles = 0;
    int max_cycles = 100000000000;

    while (!Verilated::gotFinish() && cycles < max_cycles) {
        rsa->clk = !rsa->clk;
        rsa->eval();     

        if (rsa->done) { 
            printf("Ciphertext: %x\n", rsa->cipher);
        break;
        }

        cycles++;
        
    }

    delete rsa;
    return 0;
}