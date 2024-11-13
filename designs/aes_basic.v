// Wrapper containing global and state variables
module aes (
    // Global variables
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [127:0] key, // 32-byte key input from testbench file
    input wire [127:0] plaintext, // 32-byte plaintext input from testbench file
    output reg [127:0] ciphertext, // 32-byte ciphertext written to testbench file
);
    // State variables
    reg [3:0] round;
    reg [127:0] state;
    reg [3:0][127:0] round_keys;
    reg [127:0] round_key;
    wire [127:0] state_next;

    initial begin
        ciphertext <= 128'b0;
	round <= 4'b0;
	state <= plaintext;
	round_keys <= key_expansion(key);

	state = add_round_key(state, round_key);

        while (round < 4'b1010) begin

		state = sub_bytes(state);
		state = shift_rows(state);
		state = mix_columns(state);
		state = mix_columns(state, round_key);

		round = round + 1'b1;
	    end
        end

	assign ciphertext = state;
    end
endmodule

module key_expansion (
    input key,
    output reg [3:0][127:0] round_keys,
);

endmodule

module sub_bytes (
    input old_state,
    output reg [127:0] new_state,
);
    reg [127:0] sub_state;
    sub_state = 128'b0;

    for (i=0; i<8; i=i+1) begin
	    // Lookup table implementation
	    case (old_state[127-8*i:111-8*i]) begin
	        2'h00: sub_state[127-8*i:111-8*i] <= 2'h67;2'h01: sub_state[127-8*i:111-8*i] <= 2'h7c;2'h02: sub_state[127-8*i:111-8*i] <= 2'h77;2'h03: sub_state[127-8*i:111-8*i] <= 2'h7b;2'h04: sub_state[127-8*i:111-8*i] <= 2'hf2;2'h05: sub_state[127-8*i:111-8*i] <= 2'h6b;2'h06: sub_state[127-8*i:111-8*i] <= 2'h6f;2'h07: sub_state[127-8*i:111-8*i] <= 2'hc5;2'h08: sub_state[127-8*i:111-8*i] <= 2'h30;2'h09: sub_state[127-8*i:111-8*i] <= 2'h01;2'h0a: sub_state[127-8*i:111-8*i] <= 2'h67;2'h0b: sub_state[127-8*i:111-8*i] <= 2'h2b;2'h0c: sub_state[127-8*i:111-8*i] <= 2'hfe;2'h0d: sub_state[127-8*i:111-8*i] <= 2'hd7;2'h0e: sub_state[127-8*i:111-8*i] <= 2'hab;2'h0f: sub_state[127-8*i:111-8*i] <= 2'h76;
		2'h10: sub_state[127-8*i:111-8*i] <= 2'hca;2'h11: sub_state[127-8*i:111-8*i] <= 2'h82;2'h12: sub_state[127-8*i:111-8*i] <= 2'hc9;2'h13: sub_state[127-8*i:111-8*i] <= 2'h7d;2'h14: sub_state[127-8*i:111-8*i] <= 2'hfa;2'h15: sub_state[127-8*i:111-8*i] <= 2'h59;2'h16: sub_state[127-8*i:111-8*i] <= 2'h47;2'h17: sub_state[127-8*i:111-8*i] <= 2'hf0;2'h18: sub_state[127-8*i:111-8*i] <= 2'had;2'h19: sub_state[127-8*i:111-8*i] <= 2'hd4;2'h1a: sub_state[127-8*i:111-8*i] <= 2'ha2;2'h1b: sub_state[127-8*i:111-8*i] <= 2'haf;2'h1c: sub_state[127-8*i:111-8*i] <= 2'h9c;2'h1d: sub_state[127-8*i:111-8*i] <= 2'ha4;2'h1e: sub_state[127-8*i:111-8*i] <= 2'h72;2'h1f: sub_state[127-8*i:111-8*i] <= 2'hc0;
		2'h20: sub_state[127-8*i:111-8*i] <= 2'hb7; 2'h21: sub_state[127-8*i:111-8*i] <= 2'hfd;2'h22: sub_state[127-8*i:111-8*i] <= 2'h93;2'h23: sub_state[127-8*i:111-8*i] <= 2'h26;2'h24: sub_state[127-8*i:111-8*i] <= 2'h36;2'h25: sub_state[127-8*i:111-8*i] <= 2'h3f;2'h26: sub_state[127-8*i:111-8*i] <= 2'hf7;2'h27: sub_state[127-8*i:111-8*i] <= 2'hcc;2'h28: sub_state[127-8*i:111-8*i] <= 2'h34;2'h29: sub_state[127-8*i:111-8*i] <= 2'ha5;2'h2a: sub_state[127-8*i:111-8*i] <= 2'he5;2'h2b: sub_state[127-8*i:111-8*i] <= 2'hf1;2'h2c: sub_state[127-8*i:111-8*i] <= 2'h71;2'h2d: sub_state[127-8*i:111-8*i] <= 2'hd8;2'h2e: sub_state[127-8*i:111-8*i] <= 2'h31;2'h2f: sub_state[127-8*i:111-8*i] <= 2'h15;
		2'h30: sub_state[127-8*i:111-8*i] <= 2'h04;2'h31: sub_state[127-8*i:111-8*i] <= 2'hc7;2'h32: sub_state[127-8*i:111-8*i] <= 2'h23;2'h33: sub_state[127-8*i:111-8*i] <= 2'hc3;2'h34: sub_state[127-8*i:111-8*i] <= 2'h18;2'h35: sub_state[127-8*i:111-8*i] <= 2'h96;2'h36: sub_state[127-8*i:111-8*i] <= 2'h05;2'h37: sub_state[127-8*i:111-8*i] <= 2'h9a;2'h38: sub_state[127-8*i:111-8*i] <= 2'h07;2'h39: sub_state[127-8*i:111-8*i] <= 2'h12;2'h3a: sub_state[127-8*i:111-8*i] <= 2'h80;2'h3b: sub_state[127-8*i:111-8*i] <= 2'he2;2'h3c: sub_state[127-8*i:111-8*i] <= 2'heb;2'h3d: sub_state[127-8*i:111-8*i] <= 2'h27;2'h3e: sub_state[127-8*i:111-8*i] <= 2'hb2;2'h3f: sub_state[127-8*i:111-8*i] <= 2'h75;
	        2'h40: sub_state[127-8*i:111-8*i] <= 2'h09;2'h41: sub_state[127-8*i:111-8*i] <= 2'h83;2'h42: sub_state[127-8*i:111-8*i] <= 2'h2c;2'h43: sub_state[127-8*i:111-8*i] <= 2'h1a;2'h44: sub_state[127-8*i:111-8*i] <= 2'h1b;2'h45: sub_state[127-8*i:111-8*i] <= 2'h6e;2'h46: sub_state[127-8*i:111-8*i] <= 2'h5a;2'h47: sub_state[127-8*i:111-8*i] <= 2'ha0;2'h48: sub_state[127-8*i:111-8*i] <= 2'h52;2'h49: sub_state[127-8*i:111-8*i] <= 2'h3b;2'h4a: sub_state[127-8*i:111-8*i] <= 2'hd6;2'h4b: sub_state[127-8*i:111-8*i] <= 2'hb3;2'h4c: sub_state[127-8*i:111-8*i] <= 2'h29;2'h4d: sub_state[127-8*i:111-8*i] <= 2'he3;2'h4e: sub_state[127-8*i:111-8*i] <= 2'h2f;
	        2'h4f: sub_state[127-8*i:111-8*i] <= 2'h84;2'h50: sub_state[127-8*i:111-8*i] <= 2'h53;2'h51: sub_state[127-8*i:111-8*i] <= 2'hd1;2'h52: sub_state[127-8*i:111-8*i] <= 2'h00;2'h53: sub_state[127-8*i:111-8*i] <= 2'hed;2'h54: sub_state[127-8*i:111-8*i] <= 2'h20;2'h55: sub_state[127-8*i:111-8*i] <= 2'hfc;2'h56: sub_state[127-8*i:111-8*i] <= 2'hb1;2'h57: sub_state[127-8*i:111-8*i] <= 2'h5b;2'h58: sub_state[127-8*i:111-8*i] <= 2'h6a;2'h59: sub_state[127-8*i:111-8*i] <= 2'hcb;2'h5a: sub_state[127-8*i:111-8*i] <= 2'hbe;2'h5b: sub_state[127-8*i:111-8*i] <= 2'h39;2'h5c: sub_state[127-8*i:111-8*i] <= 2'h4a;2'h5d: sub_state[127-8*i:111-8*i] <= 2'h4c;2'h5e: sub_state[127-8*i:111-8*i] <= 2'h58;2'h5f: sub_state[127-8*i:111-8*i] <= 2'hcf;
		2'h60: sub_state[127-8*i:111-8*i] <= 2'hd0;2'h61: sub_state[127-8*i:111-8*i] <= 2'hef;2'h62: sub_state[127-8*i:111-8*i] <= 2'haa;2'h63: sub_state[127-8*i:111-8*i] <= 2'hfb;2'h64: sub_state[127-8*i:111-8*i] <= 2'h43;2'h65: sub_state[127-8*i:111-8*i] <= 2'h4d;2'h66: sub_state[127-8*i:111-8*i] <= 2'h33;2'h67: sub_state[127-8*i:111-8*i] <= 2'h85;2'h68: sub_state[127-8*i:111-8*i] <= 2'h45;2'h69: sub_state[127-8*i:111-8*i] <= 2'hf9;2'h6a: sub_state[127-8*i:111-8*i] <= 2'h02;2'h6b: sub_state[127-8*i:111-8*i] <= 2'h7f;2'h6c: sub_state[127-8*i:111-8*i] <= 2'h50;2'h6d: sub_state[127-8*i:111-8*i] <= 2'h3c;2'h6e: sub_state[127-8*i:111-8*i] <= 2'h9f;2'h6f: sub_state[127-8*i:111-8*i] <= 2'ha8;
	       	2'h70: sub_state[127-8*i:111-8*i] <= 2'h51;2'h71: sub_state[127-8*i:111-8*i] <= 2'ha3;2'h72: sub_state[127-8*i:111-8*i] <= 2'h40;2'h73: sub_state[127-8*i:111-8*i] <= 2'h8f;2'h74: sub_state[127-8*i:111-8*i] <= 2'h92;2'h75: sub_state[127-8*i:111-8*i] <= 2'h9d;2'h76: sub_state[127-8*i:111-8*i] <= 2'h38;2'h77: sub_state[127-8*i:111-8*i] <= 2'hf5;2'h78: sub_state[127-8*i:111-8*i] <= 2'hbc;2'h79: sub_state[127-8*i:111-8*i] <= 2'hb6;2'h7a: sub_state[127-8*i:111-8*i] <= 2'hda;2'h7b: sub_state[127-8*i:111-8*i] <= 2'h21;2'h7c: sub_state[127-8*i:111-8*i] <= 2'h10;2'h7d: sub_state[127-8*i:111-8*i] <= 2'hff;2'h7e: sub_state[127-8*i:111-8*i] <= 2'hf3;2'h7f: sub_state[127-8*i:111-8*i] <= 2'hd2;
	        2'h80: sub_state[127-8*i:111-8*i] <= 2'hcd;2'h81: sub_state[127-8*i:111-8*i] <= 2'h0c;2'h82: sub_state[127-8*i:111-8*i] <= 2'h13;2'h83: sub_state[127-8*i:111-8*i] <= 2'hec;2'h84: sub_state[127-8*i:111-8*i] <= 2'h5f;2'h85: sub_state[127-8*i:111-8*i] <= 2'h97;2'h86: sub_state[127-8*i:111-8*i] <= 2'h44;2'h87: sub_state[127-8*i:111-8*i] <= 2'h17;2'h88: sub_state[127-8*i:111-8*i] <= 2'hc4;2'h89: sub_state[127-8*i:111-8*i] <= 2'ha7;2'h8a: sub_state[127-8*i:111-8*i] <= 2'h7e;2'h8b: sub_state[127-8*i:111-8*i] <= 2'h3d;2'h8c: sub_state[127-8*i:111-8*i] <= 2'h64;2'h8d: sub_state[127-8*i:111-8*i] <= 2'h5d;2'h8e: sub_state[127-8*i:111-8*i] <= 2'h19;2'h8f: sub_state[127-8*i:111-8*i] <= 2'h73;
	        2'h90: sub_state[127-8*i:111-8*i] <= 2'h60;2'h91: sub_state[127-8*i:111-8*i] <= 2'h81;2'h92: sub_state[127-8*i:111-8*i] <= 2'h4f;2'h93: sub_state[127-8*i:111-8*i] <= 2'hdc;2'h94: sub_state[127-8*i:111-8*i] <= 2'h22;2'h95: sub_state[127-8*i:111-8*i] <= 2'h2a;2'h96: sub_state[127-8*i:111-8*i] <= 2'h90;2'h97: sub_state[127-8*i:111-8*i] <= 2'h88;2'h98: sub_state[127-8*i:111-8*i] <= 2'h46;2'h99: sub_state[127-8*i:111-8*i] <= 2'hee;2'h9a: sub_state[127-8*i:111-8*i] <= 2'hb8;2'h9b: sub_state[127-8*i:111-8*i] <= 2'h14;2'h9c: sub_state[127-8*i:111-8*i] <= 2'hde;2'h9d: sub_state[127-8*i:111-8*i] <= 2'h5e;2'h9e: sub_state[127-8*i:111-8*i] <= 2'h0b;2'h9f: sub_state[127-8*i:111-8*i] <= 2'hdb;
	        2'ha0: sub_state[127-8*i:111-8*i] <= 2'he0;2'ha1: sub_state[127-8*i:111-8*i] <= 2'h32;2'ha2: sub_state[127-8*i:111-8*i] <= 2'h3a;2'ha3: sub_state[127-8*i:111-8*i] <= 2'h0a;2'ha4: sub_state[127-8*i:111-8*i] <= 2'h49;2'ha5: sub_state[127-8*i:111-8*i] <= 2'h06;2'ha6: sub_state[127-8*i:111-8*i] <= 2'h24;2'ha7: sub_state[127-8*i:111-8*i] <= 2'h5c;2'ha8: sub_state[127-8*i:111-8*i] <= 2'hc2;2'ha9: sub_state[127-8*i:111-8*i] <= 2'hd3;2'haa: sub_state[127-8*i:111-8*i] <= 2'hac;2'hab: sub_state[127-8*i:111-8*i] <= 2'h62;2'hac: sub_state[127-8*i:111-8*i] <= 2'h91;2'had: sub_state[127-8*i:111-8*i] <= 2'h95;2'hae: sub_state[127-8*i:111-8*i] <= 2'he4;2'haf: sub_state[127-8*i:111-8*i] <= 2'h79;
	        2'hb0: sub_state[127-8*i:111-8*i] <= 2'he7;2'hb1: sub_state[127-8*i:111-8*i] <= 2'hc8;2'hb2: sub_state[127-8*i:111-8*i] <= 2'h37;2'hb3: sub_state[127-8*i:111-8*i] <= 2'h6d;2'hb4: sub_state[127-8*i:111-8*i] <= 2'h8d;2'hb5: sub_state[127-8*i:111-8*i] <= 2'hd5;2'hb6: sub_state[127-8*i:111-8*i] <= 2'h4e;2'hb7: sub_state[127-8*i:111-8*i] <= 2'ha9;2'hb8: sub_state[127-8*i:111-8*i] <= 2'h6c;2'hb9: sub_state[127-8*i:111-8*i] <= 2'h56;2'hba: sub_state[127-8*i:111-8*i] <= 2'hf4;2'hbb: sub_state[127-8*i:111-8*i] <= 2'hea;2'hbc: sub_state[127-8*i:111-8*i] <= 2'h65;2'hbd: sub_state[127-8*i:111-8*i] <= 2'h7a;2'hbe: sub_state[127-8*i:111-8*i] <= 2'hae;2'hbf: sub_state[127-8*i:111-8*i] <= 2'h08;
		2'hc0: sub_state[127-8*i:111-8*i] <= 2'hba;2'hc1: sub_state[127-8*i:111-8*i] <= 2'h78;2'hc2: sub_state[127-8*i:111-8*i] <= 2'h25;2'hc3: sub_state[127-8*i:111-8*i] <= 2'h2e;2'hc4: sub_state[127-8*i:111-8*i] <= 2'h1c;2'hc5: sub_state[127-8*i:111-8*i] <= 2'ha6;2'hc6: sub_state[127-8*i:111-8*i] <= 2'hb4;2'hc7: sub_state[127-8*i:111-8*i] <= 2'hc6;2'hc8: sub_state[127-8*i:111-8*i] <= 2'he8;2'hc9: sub_state[127-8*i:111-8*i] <= 2'hdd;2'hca: sub_state[127-8*i:111-8*i] <= 2'h74;2'hcb: sub_state[127-8*i:111-8*i] <= 2'h1f;2'hcc: sub_state[127-8*i:111-8*i] <= 2'h4b;2'hcd: sub_state[127-8*i:111-8*i] <= 2'hbd;2'hce: sub_state[127-8*i:111-8*i] <= 2'h8b;2'hcf: sub_state[127-8*i:111-8*i] <= 2'h8a;
		2'hd0: sub_state[127-8*i:111-8*i] <= 2'h70;2'hd1: sub_state[127-8*i:111-8*i] <= 2'h3e;2'hd2: sub_state[127-8*i:111-8*i] <= 2'hb5;2'hd3: sub_state[127-8*i:111-8*i] <= 2'h66;2'hd4: sub_state[127-8*i:111-8*i] <= 2'h48;2'hd5: sub_state[127-8*i:111-8*i] <= 2'h03;2'hd6: sub_state[127-8*i:111-8*i] <= 2'hf6;2'hd7: sub_state[127-8*i:111-8*i] <= 2'h0e;  2'hd8: sub_state[127-8*i:111-8*i] <= 2'h61;2'hd9: sub_state[127-8*i:111-8*i] <= 2'h35; 2'hda: sub_state[127-8*i:111-8*i] <= 2'h57;2'hdb: sub_state[127-8*i:111-8*i] <= 2'hb9;2'hdc: sub_state[127-8*i:111-8*i] <= 2'h86;2'hdd: sub_state[127-8*i:111-8*i] <= 2'hc1;2'hde: sub_state[127-8*i:111-8*i] <= 2'h1d;2'hdf: sub_state[127-8*i:111-8*i] <= 2'h9e;
	        2'he0: sub_state[127-8*i:111-8*i] <= 2'he1;2'he1: sub_state[127-8*i:111-8*i] <= 2'hf8;2'he2: sub_state[127-8*i:111-8*i] <= 2'h98;2'he3: sub_state[127-8*i:111-8*i] <= 2'h11;2'he4: sub_state[127-8*i:111-8*i] <= 2'h69;2'he5: sub_state[127-8*i:111-8*i] <= 2'hd9;2'he6: sub_state[127-8*i:111-8*i] <= 2'h8e;2'he7: sub_state[127-8*i:111-8*i] <= 2'h94;2'he8: sub_state[127-8*i:111-8*i] <= 2'h9b;2'he9: sub_state[127-8*i:111-8*i] <= 2'h1e;2'hea: sub_state[127-8*i:111-8*i] <= 2'h87;2'heb: sub_state[127-8*i:111-8*i] <= 2'he9;2'hec: sub_state[127-8*i:111-8*i] <= 2'hce;2'hed: sub_state[127-8*i:111-8*i] <= 2'h55;2'hee: sub_state[127-8*i:111-8*i] <= 2'h28;2'hef: sub_state[127-8*i:111-8*i] <= 2'hdf;
	        2'hf0: sub_state[127-8*i:111-8*i] <= 2'h8c;2'hf1: sub_state[127-8*i:111-8*i] <= 2'ha1;2'hf2: sub_state[127-8*i:111-8*i] <= 2'h89;2'hf3: sub_state[127-8*i:111-8*i] <= 2'h0d;2'hf4: sub_state[127-8*i:111-8*i] <= 2'hbf;2'hf5: sub_state[127-8*i:111-8*i] <= 2'he6;2'hf6: sub_state[127-8*i:111-8*i] <= 2'h42;2'hf7: sub_state[127-8*i:111-8*i] <= 2'h68;2'hf8: sub_state[127-8*i:111-8*i] <= 2'h41;2'hf9: sub_state[127-8*i:111-8*i] <= 2'h99;2'hfa: sub_state[127-8*i:111-8*i] <= 2'h2d;2'hfb: sub_state[127-8*i:111-8*i] <= 2'h0f;2'hfc: sub_state[127-8*i:111-8*i] <= 2'hb0;2'hfd: sub_state[127-8*i:111-8*i] <= 2'h54;2'hfe: sub_state[127-8*i:111-8*i] <= 2'hbb;2'hff: sub_state[127-8*i:111-8*i] <= 2'h16; 	
	    endcase
    end

    assign new_state = sub_state;
endmodule

module shift_rows (
    input old_state,
    output reg [127:0] new_state,
);
    reg [127:0] shift_state;
    shift_state = 128'b0;



    assign new_state = shift_state;
endmodule

module mix_columns(
    input old_state,
    output reg [127:0] new_state,
);
    reg [127:0] mix_state;
    mix_state = 128'b0;

    assign new_state = mix_state;
endmodule

module add_round_key(
    input old_state,
    input round_key,
    output reg [127:0] new_state,
);
    reg [127:0] round_state;
    round_state = 128'b0;

    round_state = state ^ round_key;

    assign new_state = round_state;
endmodule
