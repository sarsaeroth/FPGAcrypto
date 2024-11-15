#include "Vaes.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vaes *aes = new Vaes;

    // Initialize signals
    aes->clk = 0;
    aes->rst_n = 0;
    aes->start = 0;
    aes->eval();

    // Apply reset
    std::cout << "Applying reset..." << std::endl;
    aes->rst_n = 1;
    aes->eval();

    // Toggle clock and check reset
    for (int i = 0; i < 10; i++) {
        aes->clk = !aes->clk;
        aes->eval();
        std::cout << "Cycle: " << i << ", clk: " << aes->clk << ", rst_n: " << aes->rst_n << std::endl;
    }

    // Define 128-bit key and plaintext using two 64-bit integers
    uint64_t key_high = 0x123456789ABCDEF1ULL;
    uint64_t key_low = 0x1121314151617181ULL;
    uint64_t plaintext_high = 0x3141592653589793ULL;
    uint64_t plaintext_low = 0x2384626433832795ULL;

    // Assign key to WData[4] array
    aes->key[0] = static_cast<uint32_t>(key_low & 0xFFFFFFFF);
    aes->key[1] = static_cast<uint32_t>(key_low >> 32);
    aes->key[2] = static_cast<uint32_t>(key_high & 0xFFFFFFFF);
    aes->key[3] = static_cast<uint32_t>(key_high >> 32);

    // Assign plaintext to WData[4] array
    aes->plaintext[0] = static_cast<uint32_t>(plaintext_low & 0xFFFFFFFF);
    aes->plaintext[1] = static_cast<uint32_t>(plaintext_low >> 32);
    aes->plaintext[2] = static_cast<uint32_t>(plaintext_high & 0xFFFFFFFF);
    aes->plaintext[3] = static_cast<uint32_t>(plaintext_high >> 32);

    // Start AES encryption
    std::cout << "Starting AES encryption..." << std::endl;
    aes->start = 1;
    aes->eval();
    aes->start = 0;

    // Continue clock toggling
    for (int i = 10; i < 20; i++) {
        aes->clk = !aes->clk;
        aes->eval();
        std::cout << "Cycle: " << i << ", clk: " << aes->clk << std::endl;
    }

        // Print input and output values
    std::cout << "Plaintext: " << std::hex << aes->plaintext << std::endl;
    std::cout << "Key: " << std::hex << aes->key << std::endl;
    std::cout << "Ciphertext: " << std::hex << aes->ciphertext << std::endl;

    delete aes;
    return 0;
}

