
module mux(
	input logic i0,
	input logic i1,
	input logic sel,
	output logic o
);
	assign o = sel ? i1 : i0;
endmodule: mux

module ff(
	input logic clk,
	input logic d,
	output logic q
);
	always_ff @ ( posedge clk )
		q <= d;
endmodule: ff

module top_module (
	input clk,
	input w, R, E, L,
	output Q
);

	logic dE, dL;
	logic q;
	
	mux muxE(
		.i0( q ), .i1( w ), .sel( E ), .o( dE )
	);
	
	mux muxL(
		.i0( dE ), .i1( R ), .sel( L ), .o( dL )
	);
	
	ff ff(
		.clk( clk ), .d( dL ), .q( q )
	);
	
	assign Q = q;
	
endmodule

