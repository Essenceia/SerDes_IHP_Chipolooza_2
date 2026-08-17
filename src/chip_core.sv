// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module chip_core #(
    parameter NUM_INPUT_PADS,
    parameter NUM_OUTPUT_PADS,
    parameter NUM_BIDIR_PADS,
    parameter NUM_ANALOG_PADS
    )(
    input  logic clk,       // clock
    input  logic rst_n,     // reset (active low)
    
    input  wire [NUM_INPUT_PADS-1 :0] input_in,   // Input value
    output wire [NUM_OUTPUT_PADS-1:0] output_out, // Output value
    input  wire [NUM_BIDIR_PADS-1 :0] bidir_in,   // Input value
    output wire [NUM_BIDIR_PADS-1 :0] bidir_out,  // Output value
    output wire [NUM_BIDIR_PADS-1 :0] bidir_oe,   // Output enable
    inout  wire [NUM_ANALOG_PADS-1:0] analog      // Analog
);

    // Set all bidir as output
    assign bidir_oe = '1;

    logic _unused;
    assign _unused = &bidir_in;

    logic [NUM_BIDIR_PADS-1:0] count;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            count <= '0;
        end else begin
            if (&input_in) begin
                count <= count + 1;
            end
        end
    end
    
    assign output_out = count;

    logic [31:0] sram_0_out;

    RM_IHPSG13_1P_1024x32_c2_bm_bist sram_0 (
        .A_CLK  (clk),
        .A_MEN  (1'b1),
        .A_WEN  (1'b0),
        .A_REN  (1'b1),
        .A_ADDR ('0),
        .A_DIN  ('0),
        .A_DLY  (1'b1), // tie high!
        .A_DOUT (sram_0_out),
        .A_BM   ('0),
        
        // Built-in self test port
        .A_BIST_CLK   ('0),
        .A_BIST_EN    ('0),
        .A_BIST_MEN   ('0),
        .A_BIST_WEN   ('0),
        .A_BIST_REN   ('0),
        .A_BIST_ADDR  ('0),
        .A_BIST_DIN   ('0),
        .A_BIST_BM    ('0)
    );

    logic [31:0] sram_1_out;

    RM_IHPSG13_1P_1024x32_c2_bm_bist sram_1 (
        .A_CLK  (clk),
        .A_MEN  (1'b1),
        .A_WEN  (1'b0),
        .A_REN  (1'b1),
        .A_ADDR ('0),
        .A_DIN  ('0),
        .A_DLY  (1'b1), // tie high!
        .A_DOUT (sram_1_out),
        .A_BM   ('0),
        
        // Built-in self test port
        .A_BIST_CLK   ('0),
        .A_BIST_EN    ('0),
        .A_BIST_MEN   ('0),
        .A_BIST_WEN   ('0),
        .A_BIST_REN   ('0),
        .A_BIST_ADDR  ('0),
        .A_BIST_DIN   ('0),
        .A_BIST_BM    ('0)
    );

    assign bidir_out = {7'b0, (^sram_0_out) ^ (^sram_1_out)};

endmodule

`default_nettype wire
