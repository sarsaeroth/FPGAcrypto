// Wrapper containing global and state variables
module aes (
    // Global variables
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] key, // 32-byte key input from testbench file
    input wire [127:0] plaintext, // 32-byte plaintext input from testbench file
    output reg [127:0] ciphertext, // 32-byte ciphertext written to testbench file

    // State variables
    reg [3:0] round;
    reg [127:0] state;
    reg [127:0] round_key;
    wire [127:0] round_key_next;
    wire [127:0] state_next;

    initial begin
        ciphertext <= 128'b0;
	round <= 4'b0;
	state <= plaintext;
	round_key <= key;

	state <= add_round_key(state, round_key);

        while (round < 4'b1010)
            begin
		round_key_next <= key_expansion(round, round_key);
		round_key <= round_key_next;

		state <= sub_bytes(state);
		state <= shift_rows(state);
		state <= mix_columns(state);
		state <= mix_columns(state, round_key);

		round <= round + 1;
	    end
        end

	ciphertext <= state;
    end
);

module key_expansion (
);

module sub_bytes (
);

module shift_rows (
);

module mix_columns(
);

module add_round_key(
);
