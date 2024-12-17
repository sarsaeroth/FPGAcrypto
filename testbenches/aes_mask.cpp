#include "Vaes.h"
#include "verilated.h"
#include <iostream>
#include <iomanip> // For hex formatting
#include <cstdint>

void toggle_clock(Vaes *aes, int cycles) {
    for (int i = 0; i < cycles; i++) {
        aes->clk = !aes->clk;
        aes->eval();
    }
}

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
    toggle_clock(aes, 2); // Ensure reset is evaluated over two cycles
    aes->rst_n = 1;       // Deassert reset
    toggle_clock(aes, 2); // Ensure reset deassertion propagates

    // Define 128-bit key, plaintext, and mask
    uint64_t key_high = 0xa7a25af34eb38425ULL;
    uint64_t key_low = 0xaebf1098a02227cbULL;
    uint64_t plaintext_high = 0x3141592653589793ULL;
    uint64_t plaintext_low = 0x2384626433832795ULL;
    uint64_t mask_high = 0xf7ac48936a3d1f1aULL;
    uint64_t mask_low = 0xe70a491c51df5944ULL;

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

    // Assign mask to WData[4] array
    aes->mask[0] = static_cast<uint32_t>(mask_low & 0xFFFFFFFF);
    aes->mask[1] = static_cast<uint32_t>(mask_low >> 32);
    aes->mask[2] = static_cast<uint32_t>(mask_high & 0xFFFFFFFF);
    aes->mask[3] = static_cast<uint32_t>(mask_high >> 32);

    // Start AES encryption
    std::cout << "Starting AES encryption..." << std::endl;
    aes->start = 1;
    toggle_clock(aes, 1); // Pulse start high for one clock cycle
    aes->start = 0;
    toggle_clock(aes, 1);

    // Monitor AES operation
    int max_cycles = 50;
    bool ready = false;
    for (int i = 0; i < max_cycles; i++) {
        toggle_clock(aes, 1);
        if (aes->ready) {
            ready = true;
            break;
        }
    }
    // Print input and output values
    std::cout << "Plaintext:  0x" << std::hex << plaintext_high << plaintext_low << std::endl;
    std::cout << "Key:        0x" << std::hex << key_high << key_low << std::endl;
    std::cout << "Ciphertext: 0x"
              << std::hex
              << ((uint64_t)aes->ciphertext[3] << 32 | aes->ciphertext[2])
              << ((uint64_t)aes->ciphertext[1] << 32 | aes->ciphertext[0])
              << std::endl;

    // Cleanup
    delete aes;
    return 0;
}
