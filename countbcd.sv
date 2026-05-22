
/*
 * Build a 4-digit BCD (binary-coded decimal) counter.
 * Each decimal digit is encoded using 4 bits: q[3:0] is the ones digit, q[7:4] is the tens digit, etc. 
 * For digits [3:1], also output an enable signal indicating when each of the upper three digits should be incremented.
 */

module top_module(
	input clk,
	input reset,   // Synchronous active-high reset
	output [3:1] ena,
	output [15:0] q
);

	logic [ 3:0 ] [ 3:0 ] q_ff, q_c;
	logic [ 3:0 ] ena_c ;

    assign q = q_ff[ 3:0 ];
	assign ena_c =
	{
		1'( q_ff[ 2:0 ] === 12'h999 ),
		1'( q_ff[ 1:0 ] === 8'h99 ),
		1'( q_ff[ 0:0 ] === 4'h9 ),
		1'b1 // always increment LSB
	};
	assign ena = ena_c[ 3:1 ];

	always_ff @ ( posedge clk )
	begin
		if ( reset ) q_ff <= '{ default: 'h0 };
		else q_ff <= q_c;
	end

	always_comb
	begin
		q_c = q_ff;
		for ( int i=0; i<4; ++i )
		begin
			if ( ena_c[ i ] )
			begin
				q_c[ i ] = ( q_ff[ i ]===4'h9 ) ? 4'h0 : ( q_ff[ i ]+1'h1 );
			end
		end

	end

endmodule

