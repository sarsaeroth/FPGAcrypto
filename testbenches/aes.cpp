#include "Vmodule.h"  // Verilator generated header for the AES core
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate AES core
    Vmodule *aes = new Vmodule;

    // Apply inputs to the AES core
    aes->key = 0x2b7e151628aed2a6abf7158809cf4f3c;  // Example key
    aes->plaintext = 0x6bc1bee22e409f96e93d7e117393172a;  // Example plaintext
    aes->start = 1;

    // Run simulation
    while (!aes->ready) {
        aes->eval();
    }

    // Read ciphertext output
    printf("Ciphertext: %x\n", aes->ciphertext);

    delete aes;
    return 0;
}

