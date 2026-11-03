`timescale 1ns / 1ps

module sky130_sram_1kbyte_1rw1r_32x256_8 (
    // Port 0: Read/Write
    input  wire        clk0,   // Clock
    input  wire        csb0,   // Active-low chip select
    input  wire        web0,   // Active-low write enable
    input  wire [3:0]  wmask0, // 4-bit write mask (1 bit per byte)
    input  wire [7:0]  addr0,  // 8-bit address for 256 words
    input  wire [31:0] din0,   // 32-bit data input
    output reg  [31:0] dout0,  // 32-bit data output

    // Port 1: Read Only
    input  wire        clk1,   // Clock
    input  wire        csb1,   // Active-low chip select
    input  wire [7:0]  addr1,  // 8-bit address for 256 words
    output reg  [31:0] dout1   // 32-bit data output
);

    // 256 words of 32 bits (1 kbyte total)
    reg [31:0] mem [0:255];

    // Port 0 Logic (RW)
    always @(posedge clk0) begin
        if (!csb0) begin
            if (!web0) begin
                if (wmask0[0]) mem[addr0][7:0]   <= din0[7:0];
                if (wmask0[1]) mem[addr0][15:8]  <= din0[15:8];
                if (wmask0[2]) mem[addr0][23:16] <= din0[23:16];
                if (wmask0[3]) mem[addr0][31:24] <= din0[31:24];
            end else begin
                dout0 <= mem[addr0];
            end
        end
    end

    // Port 1 Logic (Read Only)
    always @(posedge clk1) begin
        if (!csb1) begin
            dout1 <= mem[addr1];
        end
    end

endmodule
