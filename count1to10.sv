
module top_module(
	input clk,
	input reset,
	output [ 3:0 ] q
);

	always_ff @ ( posedge clk )
	begin
	if ( reset || q===4'hA ) q <= 4'h1;
		else q <= q + 4'h1;
	end

endmodule

