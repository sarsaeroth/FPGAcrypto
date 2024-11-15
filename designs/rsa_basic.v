module rsa_top(
    input clk,
    input reset,
    input [31:0] message,    // Input message (plaintext)
    input [31:0] e,          // Public exponent
    input [31:0] n,          // Modulus (public key part)
    output reg [31:0] cipher // Output ciphertext
);
    reg [31:0] result;
    reg [31:0] base;
    reg [31:0] exponent;
    reg [31:0] modulus;
    reg [31:0] temp;
    reg done;

 // State machine states
    parameter IDLE = 0;
    parameter COMPUTE = 1;
    parameter DONE = 2;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            result <= 32'd1;
            base <= 0;
            exponent <= 0;
            modulus <= 0;
            done <= 0;
            cipher <= 0;
        end else begin
            case (state)
                IDLE: begin
                    result <= 32'd1;
                    base <= message % n;
                    exponent <= e;
                    modulus <= n;
                    state <= COMPUTE;
                    done <= 0;
                end

                COMPUTE: begin
                    if (exponent > 0) begin
                        if (exponent[0] == 1) begin
                            result <= (result * base) % modulus;
                        end
                        exponent <= exponent >> 1;
                        base <= (base * base) % modulus;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    cipher <= result;
                    done <= 1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule