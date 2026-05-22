
module top_module(
	input clk,
	input slowena,
	input reset,
	output [ 3:0 ] q
);

	always_ff @ ( posedge clk )
	begin
		if ( reset ) q <= 4'h0;
		else if ( slowena ) q <= ( q===4'h9 ) ? 4'h0 : q + 4'h1;
	end

endmodule

