module tb_rsa_top;
    reg clk;
    reg reset;
    reg [15:0] message;
    reg [15:0] e;
    reg [15:0] n;
    wire [15:0] cipher;

    rsa_top uut (
        .clk(clk),
        .reset(reset),
        .message(message),
        .e(e),
        .n(n),
        .cipher(cipher)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        reset = 1;
        #10 reset = 0;

        // Test case: message = 7, e = 5, n = 21
        message = 16'd7;
        e = 16'd5;
        n = 16'd21;

        #100;
        $display("Ciphertext: %d", cipher);

        $stop;
    end
endmodule

