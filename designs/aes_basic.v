module aes (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] key,
    input wire [127:0] plaintext,
    output reg [127:0] ciphertext,
    output reg round_start,
    output reg round_end
);
    // FSM states
    typedef enum reg [2:0] {
        IDLE,
        INIT,
        SUB_BYTES,
        SHIFT_ROWS,
        MIX_COLUMNS,
        ADD_ROUND_KEY,
        FINAL_ROUND,
        DONE
    } aes_state_t;

    // State variables
    aes_state_t current_state, next_state;
    reg [127:0] state;
    reg [127:0] round_keys [10:0];
    reg [127:0] round_key;
    integer round;

    // Cycle counters for timing
    reg [31:0] sub_bytes_cycles;
    reg [31:0] shift_rows_cycles;
    reg [31:0] mix_columns_cycles;
    reg [31:0] add_round_key_cycles;

    // Internal wires for submodule outputs
    wire [127:0] state_after_sub_bytes;
    wire [127:0] state_after_shift_rows;
    wire [127:0] state_after_mix_columns;
    wire [127:0] state_after_add_round_key;

    // Instantiate submodules
    key_expansion u_key_expansion (
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
	.key(key),
	.round_keys(round_keys)
    );
    sub_bytes u_sub_bytes (
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
        .old_state(state),
        .new_state(state_after_sub_bytes)
    );
    shift_rows u_shift_rows (
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
        .old_state(state_after_sub_bytes),
        .new_state(state_after_shift_rows)
    );
    mix_columns u_mix_columns (
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
        .old_state(state_after_shift_rows),
        .new_state(state_after_mix_columns)
    );
    add_round_key u_add_round_key (
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
        .old_state(state_after_mix_columns),
        .round_key(round_key),
        .new_state(state_after_add_round_key)
    );

    // FSM state reset and cycle counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            round <= 0;
            state <= 128'b0;
            ciphertext <= 128'b0;
            round_start <= 0;
            round_end <= 0;
            sub_bytes_cycles <= 0;
            shift_rows_cycles <= 0;
            mix_columns_cycles <= 0;
            add_round_key_cycles <= 0;
        end else begin
            current_state <= next_state;

            // Update round count and state
            if (current_state == INIT) begin
                state <= plaintext ^ round_keys[0];
                round <= 1;
                round_key <= round_keys[round];
                round_start <= 1;
                round_end <= 0;
                sub_bytes_cycles <= 0;
                shift_rows_cycles <= 0;
                mix_columns_cycles <= 0;
                add_round_key_cycles <= 0;
		$display("Plaintext: %h", plaintext);
		$display("Key: %h", key);
		$display("Round Key 0: %h", round_keys[0]);
		$display("Initial State (Plaintext ^ Round Key 0): %h", state);
		$display("Initial State: %h", state);
            end else if (current_state == SUB_BYTES) begin
                state <= state_after_sub_bytes;
                sub_bytes_cycles <= sub_bytes_cycles + 1;
		$display("After SubBytes (Round %0d): %h", round, state);
            end else if (current_state == SHIFT_ROWS) begin
                state <= state_after_shift_rows;
                shift_rows_cycles <= shift_rows_cycles + 1;
		$display("After ShiftRows (Round %0d): %h", round, state);
            end else if (current_state == MIX_COLUMNS) begin
                state <= state_after_mix_columns;
                mix_columns_cycles <= mix_columns_cycles + 1;
		 $display("After MixColumns (Round %0d): %h", round, state);
            end else if (current_state == ADD_ROUND_KEY) begin
                state <= state_after_add_round_key;
                round_key <= round_keys[round];
                round <= round + 1;
                add_round_key_cycles <= add_round_key_cycles + 1;
		$display("Round Key (Round %0d): %h", round, round_key);
		$display("After AddRoundKey (Round %0d): %h", round, state);

                // Display cycle counts at the end of the round
                round_end <= 1;
                $display("End of Round %0d:", round);
                $display("  SubBytes cycles:     %0d", sub_bytes_cycles);
                $display("  ShiftRows cycles:    %0d", shift_rows_cycles);
                $display("  MixColumns cycles:   %0d", mix_columns_cycles);
                $display("  AddRoundKey cycles:  %0d", add_round_key_cycles);
            end else if (current_state == FINAL_ROUND) begin
                state <= state ^ round_keys[10];
                ciphertext <= state;
                add_round_key_cycles <= add_round_key_cycles + 1;
                round_end <= 1;
		$display("Final Round Key: %h", round_keys[10]);
		$display("Final Ciphertext: %h", ciphertext);
            end

            if (current_state == DONE) begin
                $display("AES Encryption Complete:");
                $display("  Final SubBytes cycles:     %0d", sub_bytes_cycles);
                $display("  Final ShiftRows cycles:    %0d", shift_rows_cycles);
                $display("  Final MixColumns cycles:   %0d", mix_columns_cycles);
                $display("  Final AddRoundKey cycles:  %0d", add_round_key_cycles);
            end
        end
    end

    // FSM transition logic
    always @(*) begin
        next_state = current_state;
	$display("Current State: %d", current_state);

        case (current_state)
            IDLE: if (start) next_state = INIT;
            INIT: next_state = SUB_BYTES;
            SUB_BYTES: next_state = SHIFT_ROWS;
            SHIFT_ROWS: next_state = MIX_COLUMNS;
            MIX_COLUMNS: if (round < 10) next_state = ADD_ROUND_KEY;
                         else next_state = FINAL_ROUND;
            ADD_ROUND_KEY: if (round == 10) next_state = FINAL_ROUND;
                           else next_state = SUB_BYTES;
            FINAL_ROUND: next_state = DONE;
            DONE: next_state = IDLE;
        endcase
    end
endmodule


module key_expansion (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] key, // 32-byte key input
    output reg [127:0] round_keys [10:0] // 11 32-byte round keys
);
    // Internal variables
    reg [31:0] temp;
    integer i;
    
    reg [7:0] sbox [0:255];
    initial begin
        sbox[8'h00]=8'h63; sbox[8'h01]=8'h7c; sbox[8'h02]=8'h77; sbox[8'h03]=8'h7b; sbox[8'h04]=8'hf2; sbox[8'h05]=8'h6b; sbox[8'h06]=8'h6f; sbox[8'h07]=8'hc5; sbox[8'h08]=8'h30; sbox[8'h09]=8'h01; sbox[8'h0a]=8'h67; sbox[8'h0b]=8'h2b; sbox[8'h0c]=8'hfe; sbox[8'h0d]=8'hd7; sbox[8'h0e]=8'hab; sbox[8'h0f]=8'h76;
	sbox[8'h10]=8'hca; sbox[8'h11]=8'h82; sbox[8'h12]=8'hc9; sbox[8'h13]=8'h7d; sbox[8'h14]=8'hfa; sbox[8'h15]=8'h59; sbox[8'h16]=8'h47; sbox[8'h17]=8'hf0; sbox[8'h18]=8'had; sbox[8'h19]=8'hd4; sbox[8'h1a]=8'ha2; sbox[8'h1b]=8'haf; sbox[8'h1c]=8'h9c; sbox[8'h1d]=8'ha4; sbox[8'h1e]=8'h72; sbox[8'h1f]=8'hc0;
	sbox[8'h20]=8'hb7; sbox[8'h21]=8'hfd; sbox[8'h22]=8'h93; sbox[8'h23]=8'h26; sbox[8'h24]=8'h36; sbox[8'h25]=8'h3f; sbox[8'h26]=8'hf7; sbox[8'h27]=8'hcc; sbox[8'h28]=8'h34; sbox[8'h29]=8'ha5; sbox[8'h2a]=8'he5; sbox[8'h2b]=8'hf1; sbox[8'h2c]=8'h71; sbox[8'h2d]=8'hd8; sbox[8'h2e]=8'h31; sbox[8'h2f]=8'h15;
	sbox[8'h30]=8'h04; sbox[8'h31]=8'hc7; sbox[8'h32]=8'h23; sbox[8'h33]=8'hc3; sbox[8'h34]=8'h18; sbox[8'h35]=8'h96; sbox[8'h36]=8'h05; sbox[8'h37]=8'h9a; sbox[8'h38]=8'h07; sbox[8'h39]=8'h12; sbox[8'h3a]=8'h80; sbox[8'h3b]=8'he2; sbox[8'h3c]=8'heb; sbox[8'h3d]=8'h27; sbox[8'h3e]=8'hb2; sbox[8'h3f]=8'h75;
	sbox[8'h40]=8'h09; sbox[8'h41]=8'h83; sbox[8'h42]=8'h2c; sbox[8'h43]=8'h1a; sbox[8'h44]=8'h1b; sbox[8'h45]=8'h6e; sbox[8'h46]=8'h5a; sbox[8'h47]=8'ha0; sbox[8'h48]=8'h52; sbox[8'h49]=8'h3b; sbox[8'h4a]=8'hd6; sbox[8'h4b]=8'hb3; sbox[8'h4c]=8'h29; sbox[8'h4d]=8'he3; sbox[8'h4e]=8'h2f; sbox[8'h4f]=8'h84;
	sbox[8'h50]=8'h53; sbox[8'h51]=8'hd1; sbox[8'h52]=8'h00; sbox[8'h53]=8'hed; sbox[8'h54]=8'h20; sbox[8'h55]=8'hfc; sbox[8'h56]=8'hb1; sbox[8'h57]=8'h5b; sbox[8'h58]=8'h6a; sbox[8'h59]=8'hcb; sbox[8'h5a]=8'hbe; sbox[8'h5b]=8'h39; sbox[8'h5c]=8'h4a; sbox[8'h5d]=8'h4c; sbox[8'h5e]=8'h58; sbox[8'h5f]=8'hcf;
	sbox[8'h60]=8'hd0; sbox[8'h61]=8'hef; sbox[8'h62]=8'haa; sbox[8'h63]=8'hfb; sbox[8'h64]=8'h43; sbox[8'h65]=8'h4d; sbox[8'h66]=8'h33; sbox[8'h67]=8'h85; sbox[8'h68]=8'h45; sbox[8'h69]=8'hf9; sbox[8'h6a]=8'h02; sbox[8'h6b]=8'h7f; sbox[8'h6c]=8'h50; sbox[8'h6d]=8'h3c; sbox[8'h6e]=8'h9f; sbox[8'h6f]=8'ha8;
	sbox[8'h70]=8'h51; sbox[8'h71]=8'ha3; sbox[8'h72]=8'h40; sbox[8'h73]=8'h8f; sbox[8'h74]=8'h92; sbox[8'h75]=8'h9d; sbox[8'h76]=8'h38; sbox[8'h77]=8'hf5; sbox[8'h78]=8'hbc; sbox[8'h79]=8'hb6; sbox[8'h7a]=8'hda; sbox[8'h7b]=8'h21; sbox[8'h7c]=8'h10; sbox[8'h7d]=8'hff; sbox[8'h7e]=8'hf3; sbox[8'h7f]=8'hd2;
	sbox[8'h80]=8'hcd; sbox[8'h81]=8'h0c; sbox[8'h82]=8'h13; sbox[8'h83]=8'hec; sbox[8'h84]=8'h5f; sbox[8'h85]=8'h97; sbox[8'h86]=8'h44; sbox[8'h87]=8'h17; sbox[8'h88]=8'hc4; sbox[8'h89]=8'ha7; sbox[8'h8a]=8'h7e; sbox[8'h8b]=8'h3d; sbox[8'h8c]=8'h64; sbox[8'h8d]=8'h5d; sbox[8'h8e]=8'h19; sbox[8'h8f]=8'h73;
	sbox[8'h90]=8'h60; sbox[8'h91]=8'h81; sbox[8'h92]=8'h4f; sbox[8'h93]=8'hdc; sbox[8'h94]=8'h22; sbox[8'h95]=8'h2a; sbox[8'h96]=8'h90; sbox[8'h97]=8'h88; sbox[8'h98]=8'h46; sbox[8'h99]=8'hee; sbox[8'h9a]=8'hb8; sbox[8'h9b]=8'h14; sbox[8'h9c]=8'hde; sbox[8'h9d]=8'h5e; sbox[8'h9e]=8'h0b; sbox[8'h9f]=8'hdb;
	sbox[8'ha0]=8'he0; sbox[8'ha1]=8'h32; sbox[8'ha2]=8'h3a; sbox[8'ha3]=8'h0a; sbox[8'ha4]=8'h49; sbox[8'ha5]=8'h06; sbox[8'ha6]=8'h24; sbox[8'ha7]=8'h5c; sbox[8'ha8]=8'hc2; sbox[8'ha9]=8'hd3; sbox[8'haa]=8'hac; sbox[8'hab]=8'h62; sbox[8'hac]=8'h91; sbox[8'had]=8'h95; sbox[8'hae]=8'he4; sbox[8'haf]=8'h79;
	sbox[8'hb0]=8'he7; sbox[8'hb1]=8'hc8; sbox[8'hb2]=8'h37; sbox[8'hb3]=8'h6d; sbox[8'hb4]=8'h8d; sbox[8'hb5]=8'hd5; sbox[8'hb6]=8'h4e; sbox[8'hb7]=8'ha9; sbox[8'hb8]=8'h6c; sbox[8'hb9]=8'h56; sbox[8'hba]=8'hf4; sbox[8'hbb]=8'hea; sbox[8'hbc]=8'h65; sbox[8'hbd]=8'h7a; sbox[8'hbe]=8'hae; sbox[8'hbf]=8'h08;
	sbox[8'hc0]=8'hba; sbox[8'hc1]=8'h78; sbox[8'hc2]=8'h25; sbox[8'hc3]=8'h2e; sbox[8'hc4]=8'h1c; sbox[8'hc5]=8'ha6; sbox[8'hc6]=8'hb4; sbox[8'hc7]=8'hc6; sbox[8'hc8]=8'he8; sbox[8'hc9]=8'hdd; sbox[8'hca]=8'h74; sbox[8'hcb]=8'h1f; sbox[8'hcc]=8'h4b; sbox[8'hcd]=8'hbd; sbox[8'hce]=8'h8b; sbox[8'hcf]=8'h8a;
	sbox[8'hd0]=8'h70; sbox[8'hd1]=8'h3e; sbox[8'hd2]=8'hb5; sbox[8'hd3]=8'h66; sbox[8'hd4]=8'h48; sbox[8'hd5]=8'h03; sbox[8'hd6]=8'hf6; sbox[8'hd7]=8'h0e; sbox[8'hd8]=8'h61; sbox[8'hd9]=8'h35; sbox[8'hda]=8'h57; sbox[8'hdb]=8'hb9; sbox[8'hdc]=8'h86; sbox[8'hdd]=8'hc1; sbox[8'hde]=8'h1d; sbox[8'hdf]=8'h9e;
	sbox[8'he0]=8'he1; sbox[8'he1]=8'hf8; sbox[8'he2]=8'h98; sbox[8'he3]=8'h11; sbox[8'he4]=8'h69; sbox[8'he5]=8'hd9; sbox[8'he6]=8'h8e; sbox[8'he7]=8'h94; sbox[8'he8]=8'h9b; sbox[8'he9]=8'h1e; sbox[8'hea]=8'h87; sbox[8'heb]=8'he9; sbox[8'hec]=8'hce; sbox[8'hed]=8'h55; sbox[8'hee]=8'h28; sbox[8'hef]=8'hdf;
	sbox[8'hf0]=8'h8c; sbox[8'hf1]=8'ha1; sbox[8'hf2]=8'h89; sbox[8'hf3]=8'h0d; sbox[8'hf4]=8'hbf; sbox[8'hf5]=8'he6; sbox[8'hf6]=8'h42; sbox[8'hf7]=8'h68; sbox[8'hf8]=8'h41; sbox[8'hf9]=8'h99; sbox[8'hfa]=8'h2d; sbox[8'hfb]=8'h0f; sbox[8'hfc]=8'hb0; sbox[8'hfd]=8'h54; sbox[8'hfe]=8'hbb; sbox[8'hff]=8'h16;
    end

    // Precomputed Rcon values
    reg [31:0] rcon [0:11];
    initial begin
	rcon[0] = 32'hd8000000;
        rcon[1] = 32'h01000000;
        rcon[2] = 32'h02000000;
        rcon[3] = 32'h04000000;
        rcon[4] = 32'h08000000;
        rcon[5] = 32'h10000000;
        rcon[6] = 32'h20000000;
        rcon[7] = 32'h40000000;
        rcon[8] = 32'h80000000;
        rcon[9] = 32'h1b000000;
        rcon[10] = 32'h36000000;
    end

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset round keys
        round_keys[0] <= key;
        for (i = 1; i <= 10; i = i + 1) begin
            round_keys[i] <= 128'b0;
        end
    end else begin
        round_keys[0] <= key;

        for (i = 1; i <= 10; i = i + 1) begin
            // Last word of previous round key
            temp = round_keys[i - 1][127:96];

            // S-box implementation for SubWord
            temp[31:24] = sbox[temp[31:24]];
            temp[23:16] = sbox[temp[23:16]];
            temp[15:8] = sbox[temp[15:8]];
            temp[7:0] = sbox[temp[7:0]];

            // RotWord
            temp = {temp[23:0], temp[31:24]};

            // Use blocking assignments (`=`) instead of non-blocking (`<=`)
            round_keys[i][127:96] = round_keys[i - 1][127:96] ^ temp ^ rcon[i];
            round_keys[i][95:64] = round_keys[i - 1][95:64] ^ round_keys[i][127:96];
            round_keys[i][63:32] = round_keys[i - 1][63:32] ^ round_keys[i][95:64];
            round_keys[i][31:0] = round_keys[i - 1][31:0] ^ round_keys[i][63:32];
        end

        // Print round keys for debugging
        for (i = 0; i <= 10; i = i + 1) begin
            $display("Round Key %0d: %h", i, round_keys[i]);
        end
    end
end



endmodule

module sub_bytes (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] old_state,   // 128-bit input state
    output reg [127:0] new_state    // 128-bit output state after S-box substitution
);
    reg [7:0] sbox [0:255];
    initial begin
	    sbox[8'h00]=8'h63; sbox[8'h01]=8'h7c; sbox[8'h02]=8'h77; sbox[8'h03]=8'h7b; sbox[8'h04]=8'hf2; sbox[8'h05]=8'h6b; sbox[8'h06]=8'h6f; sbox[8'h07]=8'hc5; sbox[8'h08]=8'h30; sbox[8'h09]=8'h01; sbox[8'h0a]=8'h67; sbox[8'h0b]=8'h2b; sbox[8'h0c]=8'hfe; sbox[8'h0d]=8'hd7; sbox[8'h0e]=8'hab; sbox[8'h0f]=8'h76;
	    sbox[8'h10]=8'hca; sbox[8'h11]=8'h82; sbox[8'h12]=8'hc9; sbox[8'h13]=8'h7d; sbox[8'h14]=8'hfa; sbox[8'h15]=8'h59; sbox[8'h16]=8'h47; sbox[8'h17]=8'hf0; sbox[8'h18]=8'had; sbox[8'h19]=8'hd4; sbox[8'h1a]=8'ha2; sbox[8'h1b]=8'haf; sbox[8'h1c]=8'h9c; sbox[8'h1d]=8'ha4; sbox[8'h1e]=8'h72; sbox[8'h1f]=8'hc0;
	    sbox[8'h20]=8'hb7; sbox[8'h21]=8'hfd; sbox[8'h22]=8'h93; sbox[8'h23]=8'h26; sbox[8'h24]=8'h36; sbox[8'h25]=8'h3f; sbox[8'h26]=8'hf7; sbox[8'h27]=8'hcc; sbox[8'h28]=8'h34; sbox[8'h29]=8'ha5; sbox[8'h2a]=8'he5; sbox[8'h2b]=8'hf1; sbox[8'h2c]=8'h71; sbox[8'h2d]=8'hd8; sbox[8'h2e]=8'h31; sbox[8'h2f]=8'h15;
	    sbox[8'h30]=8'h04; sbox[8'h31]=8'hc7; sbox[8'h32]=8'h23; sbox[8'h33]=8'hc3; sbox[8'h34]=8'h18; sbox[8'h35]=8'h96; sbox[8'h36]=8'h05; sbox[8'h37]=8'h9a; sbox[8'h38]=8'h07; sbox[8'h39]=8'h12; sbox[8'h3a]=8'h80; sbox[8'h3b]=8'he2; sbox[8'h3c]=8'heb; sbox[8'h3d]=8'h27; sbox[8'h3e]=8'hb2; sbox[8'h3f]=8'h75;
	    sbox[8'h40]=8'h09; sbox[8'h41]=8'h83; sbox[8'h42]=8'h2c; sbox[8'h43]=8'h1a; sbox[8'h44]=8'h1b; sbox[8'h45]=8'h6e; sbox[8'h46]=8'h5a; sbox[8'h47]=8'ha0; sbox[8'h48]=8'h52; sbox[8'h49]=8'h3b; sbox[8'h4a]=8'hd6; sbox[8'h4b]=8'hb3; sbox[8'h4c]=8'h29; sbox[8'h4d]=8'he3; sbox[8'h4e]=8'h2f; sbox[8'h4f]=8'h84;
	    sbox[8'h50]=8'h53; sbox[8'h51]=8'hd1; sbox[8'h52]=8'h00; sbox[8'h53]=8'hed; sbox[8'h54]=8'h20; sbox[8'h55]=8'hfc; sbox[8'h56]=8'hb1; sbox[8'h57]=8'h5b; sbox[8'h58]=8'h6a; sbox[8'h59]=8'hcb; sbox[8'h5a]=8'hbe; sbox[8'h5b]=8'h39; sbox[8'h5c]=8'h4a; sbox[8'h5d]=8'h4c; sbox[8'h5e]=8'h58; sbox[8'h5f]=8'hcf;
	    sbox[8'h60]=8'hd0; sbox[8'h61]=8'hef; sbox[8'h62]=8'haa; sbox[8'h63]=8'hfb; sbox[8'h64]=8'h43; sbox[8'h65]=8'h4d; sbox[8'h66]=8'h33; sbox[8'h67]=8'h85; sbox[8'h68]=8'h45; sbox[8'h69]=8'hf9; sbox[8'h6a]=8'h02; sbox[8'h6b]=8'h7f; sbox[8'h6c]=8'h50; sbox[8'h6d]=8'h3c; sbox[8'h6e]=8'h9f; sbox[8'h6f]=8'ha8;
	    sbox[8'h70]=8'h51; sbox[8'h71]=8'ha3; sbox[8'h72]=8'h40; sbox[8'h73]=8'h8f; sbox[8'h74]=8'h92; sbox[8'h75]=8'h9d; sbox[8'h76]=8'h38; sbox[8'h77]=8'hf5; sbox[8'h78]=8'hbc; sbox[8'h79]=8'hb6; sbox[8'h7a]=8'hda; sbox[8'h7b]=8'h21; sbox[8'h7c]=8'h10; sbox[8'h7d]=8'hff; sbox[8'h7e]=8'hf3; sbox[8'h7f]=8'hd2;
	    sbox[8'h80]=8'hcd; sbox[8'h81]=8'h0c; sbox[8'h82]=8'h13; sbox[8'h83]=8'hec; sbox[8'h84]=8'h5f; sbox[8'h85]=8'h97; sbox[8'h86]=8'h44; sbox[8'h87]=8'h17; sbox[8'h88]=8'hc4; sbox[8'h89]=8'ha7; sbox[8'h8a]=8'h7e; sbox[8'h8b]=8'h3d; sbox[8'h8c]=8'h64; sbox[8'h8d]=8'h5d; sbox[8'h8e]=8'h19; sbox[8'h8f]=8'h73;
	    sbox[8'h90]=8'h60; sbox[8'h91]=8'h81; sbox[8'h92]=8'h4f; sbox[8'h93]=8'hdc; sbox[8'h94]=8'h22; sbox[8'h95]=8'h2a; sbox[8'h96]=8'h90; sbox[8'h97]=8'h88; sbox[8'h98]=8'h46; sbox[8'h99]=8'hee; sbox[8'h9a]=8'hb8; sbox[8'h9b]=8'h14; sbox[8'h9c]=8'hde; sbox[8'h9d]=8'h5e; sbox[8'h9e]=8'h0b; sbox[8'h9f]=8'hdb;
	    sbox[8'ha0]=8'he0; sbox[8'ha1]=8'h32; sbox[8'ha2]=8'h3a; sbox[8'ha3]=8'h0a; sbox[8'ha4]=8'h49; sbox[8'ha5]=8'h06; sbox[8'ha6]=8'h24; sbox[8'ha7]=8'h5c; sbox[8'ha8]=8'hc2; sbox[8'ha9]=8'hd3; sbox[8'haa]=8'hac; sbox[8'hab]=8'h62; sbox[8'hac]=8'h91; sbox[8'had]=8'h95; sbox[8'hae]=8'he4; sbox[8'haf]=8'h79;
	    sbox[8'hb0]=8'he7; sbox[8'hb1]=8'hc8; sbox[8'hb2]=8'h37; sbox[8'hb3]=8'h6d; sbox[8'hb4]=8'h8d; sbox[8'hb5]=8'hd5; sbox[8'hb6]=8'h4e; sbox[8'hb7]=8'ha9; sbox[8'hb8]=8'h6c; sbox[8'hb9]=8'h56; sbox[8'hba]=8'hf4; sbox[8'hbb]=8'hea; sbox[8'hbc]=8'h65; sbox[8'hbd]=8'h7a; sbox[8'hbe]=8'hae; sbox[8'hbf]=8'h08;
	    sbox[8'hc0]=8'hba; sbox[8'hc1]=8'h78; sbox[8'hc2]=8'h25; sbox[8'hc3]=8'h2e; sbox[8'hc4]=8'h1c; sbox[8'hc5]=8'ha6; sbox[8'hc6]=8'hb4; sbox[8'hc7]=8'hc6; sbox[8'hc8]=8'he8; sbox[8'hc9]=8'hdd; sbox[8'hca]=8'h74; sbox[8'hcb]=8'h1f; sbox[8'hcc]=8'h4b; sbox[8'hcd]=8'hbd; sbox[8'hce]=8'h8b; sbox[8'hcf]=8'h8a;
	    sbox[8'hd0]=8'h70; sbox[8'hd1]=8'h3e; sbox[8'hd2]=8'hb5; sbox[8'hd3]=8'h66; sbox[8'hd4]=8'h48; sbox[8'hd5]=8'h03; sbox[8'hd6]=8'hf6; sbox[8'hd7]=8'h0e; sbox[8'hd8]=8'h61; sbox[8'hd9]=8'h35; sbox[8'hda]=8'h57; sbox[8'hdb]=8'hb9; sbox[8'hdc]=8'h86; sbox[8'hdd]=8'hc1; sbox[8'hde]=8'h1d; sbox[8'hdf]=8'h9e;
	    sbox[8'he0]=8'he1; sbox[8'he1]=8'hf8; sbox[8'he2]=8'h98; sbox[8'he3]=8'h11; sbox[8'he4]=8'h69; sbox[8'he5]=8'hd9; sbox[8'he6]=8'h8e; sbox[8'he7]=8'h94; sbox[8'he8]=8'h9b; sbox[8'he9]=8'h1e; sbox[8'hea]=8'h87; sbox[8'heb]=8'he9; sbox[8'hec]=8'hce; sbox[8'hed]=8'h55; sbox[8'hee]=8'h28; sbox[8'hef]=8'hdf;
	    sbox[8'hf0]=8'h8c; sbox[8'hf1]=8'ha1; sbox[8'hf2]=8'h89; sbox[8'hf3]=8'h0d; sbox[8'hf4]=8'hbf; sbox[8'hf5]=8'he6; sbox[8'hf6]=8'h42; sbox[8'hf7]=8'h68; sbox[8'hf8]=8'h41; sbox[8'hf9]=8'h99; sbox[8'hfa]=8'h2d; sbox[8'hfb]=8'h0f; sbox[8'hfc]=8'hb0; sbox[8'hfd]=8'h54; sbox[8'hfe]=8'hbb; sbox[8'hff]=8'h16;
    end

    reg [127:0] sub_state;

    always @(*) begin
	sub_state[127:120] = sbox[old_state[127:120]];
        sub_state[119:112] = sbox[old_state[119:112]];
        sub_state[111:104] = sbox[old_state[111:104]];
        sub_state[103:96] = sbox[old_state[103:96]];
        sub_state[95:88] = sbox[old_state[95:88]];
        sub_state[87:80] = sbox[old_state[87:80]];
        sub_state[79:72] = sbox[old_state[79:72]];
        sub_state[71:64] = sbox[old_state[71:64]];
        sub_state[63:56] = sbox[old_state[63:56]];
        sub_state[55:48] = sbox[old_state[55:48]];
        sub_state[47:40] = sbox[old_state[47:40]];
        sub_state[39:32] = sbox[old_state[39:32]];
        sub_state[31:24] = sbox[old_state[31:24]];
        sub_state[23:16] = sbox[old_state[23:16]];
        sub_state[15:8] = sbox[old_state[15:8]];
        sub_state[7:0] = sbox[old_state[7:0]];

	assign new_state = sub_state;
    end
endmodule

module shift_rows (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] old_state, // 128-bit input state
    output reg [127:0] new_state // 128-bit output state after row shifts
);

    reg [127:0] shift_state;

    always @(*) begin
        // First row is not shifted
        shift_state[127:120] = old_state[127:120];
        shift_state[119:112] = old_state[119:112];
        shift_state[111:104] = old_state[111:104];
        shift_state[103:96] = old_state[103:96];

        // Second row is shifted left by 1 byte
        shift_state[95:88] = old_state[87:80];
        shift_state[87:80] = old_state[79:72];
        shift_state[79:72] = old_state[71:64];
        shift_state[71:64] = old_state[95:88];

        // Third row is shifted left by 2 bytes
        shift_state[63:56] = old_state[47:40];
        shift_state[55:48] = old_state[39:32];
        shift_state[47:40] = old_state[63:56];
        shift_state[39:32] = old_state[55:48];

        // Fourth row is shifted left by 3 bytes
        shift_state[31:24] = old_state[7:0];
        shift_state[23:16] = old_state[31:24];
        shift_state[15:8] = old_state[23:16];
        shift_state[7:0] = old_state[15:8];

	assign new_state = shift_state;
    end
endmodule

module mix_columns (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] old_state, // 128-bit input state
    output reg [127:0] new_state // 128-bit output state after MixColumns
);

    // Multiplication by 2 by bit shifting
    function [7:0] gmul2([7:0] data_byte); begin
	    if (data_byte[7] == 1) begin
	        gmul2 = (data_byte << 1) ^ 8'h1b; // Compensate for MSB
	    end else begin
		gmul2 = data_byte << 1;
	    end
        end
    endfunction

    function [7:0] gmul3(input [7:0] data_byte);
        begin
            gmul3 = gmul2(data_byte) ^ data_byte; // Multiplication by 3 is gmul2 + XOR in GF(2^8)
        end
    endfunction

    reg [127:0] mix_state;

    always @(*) begin
        // First column
        mix_state[127:120] = gmul2(old_state[127:120]) ^ gmul3(old_state[95:88]) ^ old_state[63:56] ^ old_state[31:24];
        mix_state[95:88] = old_state[127:120] ^ gmul2(old_state[95:88]) ^ gmul3(old_state[63:56]) ^ old_state[31:24];
        mix_state[63:56] = old_state[127:120] ^ old_state[95:88] ^ gmul2(old_state[63:56]) ^ gmul3(old_state[31:24]);
        mix_state[31:24] = gmul3(old_state[127:120]) ^ old_state[95:88] ^ old_state[63:56] ^ gmul2(old_state[31:24]);

        // Second column
        mix_state[119:112] = gmul2(old_state[119:112]) ^ gmul3(old_state[87:80]) ^ old_state[55:48] ^ old_state[23:16];
        mix_state[87:80] = old_state[119:112] ^ gmul2(old_state[87:80]) ^ gmul3(old_state[55:48]) ^ old_state[23:16];
        mix_state[55:48] = old_state[119:112] ^ old_state[87:80] ^ gmul2(old_state[55:48]) ^ gmul3(old_state[23:16]);
        mix_state[23:16] = gmul3(old_state[119:112]) ^ old_state[87:80] ^ old_state[55:48] ^ gmul2(old_state[23:16]);

        // Third column
        mix_state[111:104] = gmul2(old_state[111:104]) ^ gmul3(old_state[79:72]) ^ old_state[47:40] ^ old_state[15:8];
        mix_state[79:72] = old_state[111:104] ^ gmul2(old_state[79:72]) ^ gmul3(old_state[47:40]) ^ old_state[15:8];
        mix_state[47:40] = old_state[111:104] ^ old_state[79:72] ^ gmul2(old_state[47:40]) ^ gmul3(old_state[15:8]);
        mix_state[15:8] = gmul3(old_state[111:104]) ^ old_state[79:72] ^ old_state[47:40] ^ gmul2(old_state[15:8]);

        // Fourth column
        mix_state[103:96] = gmul2(old_state[103:96]) ^ gmul3(old_state[71:64]) ^ old_state[39:32] ^ old_state[7:0];
        mix_state[71:64] = old_state[103:96] ^ gmul2(old_state[71:64]) ^ gmul3(old_state[39:32]) ^ old_state[7:0];
        mix_state[39:32] = old_state[103:96] ^ old_state[71:64] ^ gmul2(old_state[39:32]) ^ gmul3(old_state[7:0]);
        mix_state[7:0] = gmul3(old_state[103:96]) ^ old_state[71:64] ^ old_state[39:32] ^ gmul2(old_state[7:0]);
    end

    // Assign the result to the output
    assign new_state = mix_state;

endmodule

module add_round_key (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] old_state, // 128-bit input state
    input wire [127:0] round_key, // 128-bit round key
    output reg [127:0] new_state // 128-bit output state after XOR
);

    // XOR the input state with the round key
    assign new_state = old_state ^ round_key;

endmodule

