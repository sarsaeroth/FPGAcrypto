#include "Vmodule.h"  // Verilator generated header for the AES core
#include "verilated.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate AES core
    Vmodule *aes = new Vmodule;

    // Apply inputs to the AES core
    aes->key = 0x123456789ABCDEF11121314151617181;
    aes->plaintext = 0x31415926535897932384626433832795;
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

