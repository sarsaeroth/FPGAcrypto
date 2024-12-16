module rsa_top(
    input clk,
    input reset,
    input [31:0] message,    // message plaintext
    input [31:0] e,          // exponent
    input [31:0] n,          // modulus
    output reg [31:0] cipher, 
    output reg done
);

    reg [63:0] result;      
    reg [63:0] base;
    reg [63:0] modulus;     
    reg [31:0] exponent;

    parameter IDLE = 0, COMPUTE = 1, DONE = 2;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            result <= 64'd1;
            base <= 0;
            exponent <= 0;
            modulus <= 0;
            done <= 0;
            cipher <= 0;
        end else begin
            case (state)
                IDLE: begin
                    result <= 64'd1;
                    base <= {32'b0, message} % {32'b0, n};
                    exponent <= e;
                    modulus <= {32'b0, n};              
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
                    if (!done) begin
                        cipher <= result[31:0];
                        done <= 1;
                    end else begin
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
