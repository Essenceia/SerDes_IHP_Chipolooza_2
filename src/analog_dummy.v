// dummy analog module 
`default_nettype none

module analog_dummy #(
	parameter NUM_ANALOG_PADS = 8
)(
	`ifdef USE_POWER_PINS
	inout wire VDD, 
	inout wire VSS,
	`endif
	inout wire clk_p_io, 
	inout wire clk_n_io,
	
	inout wire tx_p_io,
	inout wire tx_n_io,
	inout wire rx_p_io,
	inout wire rx_n_io,
		
	inout wire [NUM_ANALOG_PADS-1:0] analog_io,

	output wire digital_clk_o
);

assign digital_clk_o = 1'bx; 

endmodule
