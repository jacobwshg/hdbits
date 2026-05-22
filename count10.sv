
/*
 * Build a decade counter that counts from 0 through 9, inclusive, with a period of 10.
 * The reset input is synchronous, and should reset the counter to 0.
 */

module top_module(
	input clk,
	input reset, // Synchronous active-high reset
	output [3:0] q);

	always_ff @ ( posedge clk )
	begin
		if ( reset ) q <= 4'h0;
		else q <= ( q===4'h9 ) ? 4'h0: ( q + 1'h1 );
	end
	
endmodule

