
/*
 * From a 1000 Hz clock, derive a 1 Hz signal, called OneHertz, 
 * Since we want the clock to count once per second, 
 * the OneHertz signal must be asserted for exactly one cycle each second. 
 * Build the frequency divider using modulo-10 (BCD) counters and as few other gates as possible. 
 * Also output the enable signals from each of the BCD counters you use (c_enable[0] for the fastest counter, 
 * c_enable[2] for the slowest).
 *
 * The following BCD counter is provided for you. 
 * Enable must be high for the counter to run. 
 * Reset is synchronous and set high to force the counter to zero. 
 * All counters in your circuit must directly use the same 1000 Hz signal.
 */

//	module bcdcount (
//		input clk,
//		input reset,
//		input enable,
//		output reg [3:0] Q
//	);


module top_module(
	input clk,
	input reset,
	output OneHertz,
	output [ 2:0 ] c_enable
);

	logic [ 2:0 ] [ 3:0 ] q;

	bcdcount counter_1e0(
		.clk( clk ), .reset( reset ),
		.enable( c_enable[ 0 ] ),

		.Q( q[ 0 ] )
	);
	bcdcount counter_1e1(
		.clk( clk ), .reset( reset ),
		.enable( c_enable[ 1 ] ),

		.Q( q[ 1 ] )
	);
	bcdcount counter_1e2(
		.clk( clk ), .reset( reset ),
		.enable( c_enable[ 2 ] ),

		.Q( q[ 2 ] )
	);

	assign OneHertz = ( q === 12'h999 );

	assign c_enable = 
	{
		1'( q[ 1:0 ] === 8'h99 ),
		1'( q[ 0:0 ] === 4'h9 ),
		1'b1
	};

endmodule

