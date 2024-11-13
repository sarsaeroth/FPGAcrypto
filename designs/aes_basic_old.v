module aes_core (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [3:0] rounds, // Usually 10, 12, or 14
    input wire [127:0] key, // Input from testbench file
    input wire [127:0] plaintext, // Input from testbench file
    output reg [127:0] ciphertext, 
    output reg ready
);

    reg [3:0] round;
    reg [127:0] state;
    reg [127:0] round_key;
    reg processing;
    wire [127:0] round_key_next;
    wire [127:0] state_next;

    aes_round_transform aes_round (
        .state_in(state),
        .round_key_in(round_key),
        .state_out(state_next)
    );

    aes_key_schedule key_expansion (
        .key(key),
        .round(round),
        .round_key(round_key_next)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 128'b0;
            round <= 4'b0;
            ciphertext <= 128'b0;
            ready <= 1'b1;
            processing <= 1'b0;
        end
            state <= plaintext;
            round_key <= key;
            round <= 4'b0;
            processing <= 1'b1;
            ready <= 1'b0;
        end
        else if (processing) begin
            if (round < 4'd10) begin
                state <= state_next;
                round_key <= round_key_next;
                round <= round + 1;
            end
            else begin
                ciphertext <= state;
                ready <= 1'b1;
                processing <= 1'b0;
            end
        end
    end
endmodule

module aes_round_transform (
    input wire [127:0] state_in,
    input wire [127:0] round_key_in,
    output wire [127:0] state_out
);

    // Substitute bytes, shift rows, mix columns, and add round key
    assign state_out = substitute_bytes(state_in) ^ round_key_in;

    // Substitute bytes function (simplified for clarity)
    function [127:0] substitute_bytes(input [127:0] state_in);
        // Substitute bytes logic (use a pre-defined S-box for AES)
        // ... (Simplify for example)
        substitute_bytes = state_in;  // Replace with actual S-box substitution
    endfunction

endmodule

// AES Key Schedule (simplified example)
module aes_key_schedule (
    input wire [127:0] key,
    input wire [3:0] round,
    output wire [127:0] round_key
);

    // Simplified key expansion logic (replace with full key schedule)
    assign round_key = key ^ round;  // Replace with actual key expansion logic

endmodule

