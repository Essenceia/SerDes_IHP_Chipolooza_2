// SPDX-FileCopyrightText: © 2025 LibreLane Template Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module chip_top #(
    // Signal pads
    parameter NUM_INPUT_PADS  = 10,
    parameter NUM_OUTPUT_PADS = 8,
    parameter NUM_BIDIR_PADS  = 8,
    parameter NUM_ANALOG_PADS = 8
    )(
    `ifdef USE_POWER_PINS
    inout wire IOAVDD, IODVDD,
    inout wire IOAVSS, IODVSS,
    inout wire AVDD, DVDD,
    inout wire AVSS, DVSS,
    `endif
    inout  wire clk_p_PAD,
    inout  wire clk_n_PAD,

    inout  wire rst_n_PAD,

	inout  wire tx_p_PAD,
	inout  wire tx_n_PAD,
	inout  wire rx_p_PAD,
	inout  wire rx_n_PAD,

    inout  wire [NUM_INPUT_PADS-1 :0] input_PAD,
    inout  wire [NUM_OUTPUT_PADS-1:0] output_PAD,
    inout  wire [NUM_BIDIR_PADS-1 :0] bidir_PAD,
    inout  wire [NUM_ANALOG_PADS-1:0] analog_PAD
);

    wire digital_clk;
    wire rst_n_PAD2CORE;
    wire [NUM_INPUT_PADS-1 :0] input_PAD2CORE;
    wire [NUM_OUTPUT_PADS-1:0] output_CORE2PAD;
    wire [NUM_BIDIR_PADS-1 :0] bidir_PAD2CORE;
    wire [NUM_BIDIR_PADS-1 :0] bidir_CORE2PAD;
    wire [NUM_BIDIR_PADS-1 :0] bidir_CORE2PAD_OE;
    wire [NUM_ANALOG_PADS-1:0] analog_PADRES;

    // Power/gnd
    // Analog power domain
    (* keep *)
    sg13cmos5l_IOPadIOVdd ioavdd_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IOAVDD),
        .iovss  (IOAVSS),
        .vdd    (AVDD),
        .vss    (AVSS)
        `endif
    );
    (* keep *)
    sg13cmos5l_IOPadIOVss ioavss_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IOAVDD),
        .iovss  (IOAVSS),
        .vdd    (AVDD),
        .vss    (AVSS)
        `endif
    );
    (* keep *)
    sg13cmos5l_IOPadVdd avdd_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IOAVDD),
        .iovss  (IOAVSS),
        .vdd    (AVDD),
        .vss    (AVSS)
        `endif
    );
    (* keep *)
    sg13cmos5l_IOPadVss avss_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IOAVDD),
        .iovss  (IOAVSS),
        .vdd    (AVDD),
        .vss    (AVSS)
        `endif
    );
	// Digital power domain
    (* keep *)
    sg13cmos5l_IOPadIOVdd iodvdd_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IODVDD),
        .iovss  (IODVSS),
        .vdd    (DVDD),
        .vss    (DVSS)
        `endif
    );
    (* keep *)
    sg13cmos5l_IOPadIOVss iodvss_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IODVDD),
        .iovss  (IODVSS),
        .vdd    (DVDD),
        .vss    (DVSS)
        `endif
    );
    (* keep *)
    sg13cmos5l_IOPadVdd dvdd_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IODVDD),
        .iovss  (IODVSS),
        .vdd    (DVDD),
        .vss    (DVSS)
        `endif
    );
    (* keep *)
    sg13cmos5l_IOPadVss dvss_pad  (
        `ifdef USE_POWER_PINS
        .iovdd  (IODVDD),
        .iovss  (IODVSS),
        .vdd    (DVDD),
        .vss    (DVSS)
        `endif
    );


    // Signal IO pad instances
    (* keep *)
    sg13cmos5l_IOPadIn rst_n_pad (
        `ifdef USE_POWER_PINS
        .iovdd  (IODVDD),
        .iovss  (IODVSS),
        .vdd    (DVDD),
        .vss    (DVSS),
        `endif
        .p2c    (rst_n_PAD2CORE),
        .pad    (rst_n_PAD)
    );

    generate
    for (genvar i=0; i<NUM_INPUT_PADS; i++) begin : inputs
    	(* keep *)
        sg13cmos5l_IOPadIn input_pad (
            `ifdef USE_POWER_PINS
            .iovdd  (IODVDD),
            .iovss  (IODVSS),
            .vdd    (DVDD),
            .vss    (DVSS),
            `endif
            .p2c    (input_PAD2CORE[i]),
            .pad    (input_PAD[i])
        );
    end
    endgenerate

    generate
    for (genvar i=0; i<NUM_OUTPUT_PADS; i++) begin : outputs
    	(* keep *)
        sg13cmos5l_IOPadOut30mA output_pad (
            `ifdef USE_POWER_PINS
            .iovdd  (IODVDD),
            .iovss  (IODVSS),
            .vdd    (DVDD),
            .vss    (DVSS),
            `endif
            .c2p    (output_CORE2PAD[i]),
            .pad    (output_PAD[i])
        );
    end
    endgenerate

    generate
    for (genvar i=0; i<NUM_BIDIR_PADS; i++) begin : bidirs
    	(* keep *)
        sg13cmos5l_IOPadInOut30mA bidir_pad (
            `ifdef USE_POWER_PINS
            .iovdd  (IODVDD),
            .iovss  (IODVSS),
            .vdd    (DVDD),
            .vss    (DVSS),
            `endif
            .c2p    (bidir_CORE2PAD[i]),
            .c2p_en (bidir_CORE2PAD_OE[i]),
            .p2c    (bidir_PAD2CORE[i]),
            .pad    (bidir_PAD[i])
        );
    end
    endgenerate
    
    generate
    for (genvar i=0; i<NUM_ANALOG_PADS; i++) begin : analogs
        (* keep *)
        sg13cmos5l_IOPadAnalog analog_pad (
            `ifdef USE_POWER_PINS
            .iovdd  (IOAVDD),
            .iovss  (IOAVSS),
            .vdd    (AVDD),
            .vss    (AVSS),
            `endif
            .padres (analog_PADRES[i]),
            .pad    (analog_PAD[i])
        );
    end
    endgenerate

	localparam NUM_DIFF_PAIRS_PADS = 6;
	wire [NUM_DIFF_PAIRS_PADS-1:0] diff_pair_pad;  
	wire [NUM_DIFF_PAIRS_PADS-1:0] diff_pair_padres;  
	wire clk_p, clk_n; 
	wire tx_p, tx_n;
	wire rx_p, rx_n;
	assign diff_pair_pad = { clk_p_PAD, clk_n_PAD, tx_p_PAD, tx_n_PAD, rx_p_PAD, rx_n_PAD}; 
	assign {clk_p, clk_n, tx_p, tx_n, rx_p, rx_n} = diff_pair_padres; 
    generate
    for (genvar i=0; i<NUM_DIFF_PAIRS_PADS; i++) begin : g_diff_analog_pads
        (* keep *)
        sg13cmos5l_IOPadAnalog analog_pad (
            `ifdef USE_POWER_PINS
            .iovdd  (IOAVDD),
            .iovss  (IOAVSS),
            .vdd    (AVDD),
            .vss    (AVSS),
            `endif
            .padres (diff_pair_padres[i]),
            .pad    (diff_pair_pad[i])
        );
    end
    endgenerate

    // Digital core design
    (* keep *) chip_core #(
        .NUM_INPUT_PADS  (NUM_INPUT_PADS),
        .NUM_OUTPUT_PADS (NUM_OUTPUT_PADS),
        .NUM_BIDIR_PADS  (NUM_BIDIR_PADS)
    ) i_chip_core (
	`ifdef USE_POWER_PINS
		.VDD(DVDD),
		.VSS(DVSS),
	`endif
        .clk        (digital_clk),
        .rst_n      (rst_n_PAD2CORE),
        .input_in   (input_PAD2CORE),
        .output_out (output_CORE2PAD),
        .bidir_in   (bidir_PAD2CORE),
        .bidir_out  (bidir_CORE2PAD),
        .bidir_oe   (bidir_CORE2PAD_OE)
    );

	// Dummy analog design
	(* keep *) analog_dummy #(
		.NUM_ANALOG_PADS(NUM_ANALOG_PADS)
	) m_analog (
	`ifdef USE_POWER_PINS
		.VDD(AVDD),
		.VSS(AVSS),
	`endif
		.clk_p_io(clk_p),
		.clk_n_io(clk_n),
		
		.tx_p_io(tx_p),
		.tx_n_io(tx_n),
		.rx_p_io(rx_p),
		.rx_n_io(rx_n),

		.analog_io(analog_PADRES),
		.digital_clk_o(digital_clk)
	);

endmodule
