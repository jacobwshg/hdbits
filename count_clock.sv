
/*
 * Create a set of counters suitable for use as a 12-hour clock (with am/pm indicator).
 * Your counters are clocked by a fast-running clk, with a pulse on ena whenever your clock should increment (i.e., once per second).
 *
 * reset resets the clock to 12:00 AM. 
 * pm is 0 for AM and 1 for PM. 
 * hh, mm, and ss are two BCD (Binary-Coded Decimal) digits each for hours (01-12), minutes (00-59), and seconds (00-59). 
 * Reset has higher priority than enable, and can occur even when not enabled.
 */

module top_module(
	input clk,
	input reset,
	input ena,

	output pm,
	output [7:0] hh,
	output [7:0] mm,
	output [7:0] ss
); 

	function automatic logic [ 7:0 ]
	bcd_add1( input logic [ 7:0 ] din );
		if ( din[ 3:0 ] === 4'h9 )
		begin
			// carry
			return { 4'( din[ 7:4 ] + 1'h1 ), 4'h0 };
		end 
		else
		begin
			return 8'( din + 1'h1 );
		end
	endfunction

	logic pm_c;
	logic [ 7:0 ] hh_c, mm_c, ss_c;

	//
	// flatten increment decision dependency chain
	// 
	logic
		hh_is_max, mm_is_max, ss_is_max;

	assign hh_is_max = 1'( hh === 8'h11 );
	assign mm_is_max = 1'( mm === 8'h59 );
	assign ss_is_max = 1'( ss === 8'h59 );

	always_ff @ ( posedge clk )
	begin
		if ( reset )
		begin
			pm <= 1'b0;
			hh <= 8'h12;
			mm <= 8'h00;
			ss <= 8'h00;			
		end
		else
		begin
			pm <= pm_c;
			hh <= hh_c;
			mm <= mm_c;
			ss <= ss_c;
		end
	end

	always_comb
	begin
		pm_c = pm;
		hh_c = hh;
		mm_c = mm;
		ss_c = ss;

		if ( ena ) // ss will increment
		begin

			// increment pm as necessary
			if ( hh_is_max && mm_is_max && ss_is_max )
			begin
				pm_c = !pm;
			end

			// increment hh as necessary
			if ( mm_is_max && ss_is_max )
			begin
				if ( hh === 8'h12 )
				begin
					hh_c = 8'h01;
				end
				else
				begin
					hh_c = bcd_add1( hh );
				end
			end

			// increment mm as necessary
			if ( ss_is_max )
			begin
				if ( mm_is_max )
				begin
					mm_c = 8'h00;
				end
				else
				begin
					mm_c = bcd_add1( mm );
				end
			end

			// increment ss
			if ( ss_is_max )
			begin
				ss_c = 8'h00;
			end
			else 
			begin
				ss_c = bcd_add1( ss );
			end

		end
	end

endmodule

