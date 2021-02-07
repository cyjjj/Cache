`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:01:20 01/16/2021
// Design Name:   cache
// Module Name:   C:/Users/Lenovo/Desktop/exp7/exp7_cache_3180101226/sim_cache.v
// Project Name:  exp7_cache_3180101226
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cache
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sim_cache;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] addr;
	reg store;
	reg edit;
	reg invalid;
	reg [31:0] din;

	// Outputs
	wire hit;
	wire [31:0] dout;
	wire valid;
	wire dirty;
	wire [21:0] tag;

	// Instantiate the Unit Under Test (UUT)
	cache uut (
		.clk(clk), 
		.rst(rst), 
		.addr(addr), 
		.store(store), 
		.edit(edit), 
		.invalid(invalid), 
		.din(din), 
		.hit(hit), 
		.dout(dout), 
		.valid(valid), 
		.dirty(dirty), 
		.tag(tag)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		rst = 0;
		addr = 0;
		store = 0;
		edit = 0;
		invalid = 0;
		din = 0;
        
		#210 store = 1; din = 32'h11111111; addr = 32'h00000000;
		#20 addr = 32'h00000004;
		#20 addr = 32'h000000A8;
		#20 addr = 32'h0000001C;
		#20 store = 0; addr = 32'h000000B4; din = 0;
		#100  edit = 1; din = 32'h22222222; addr = 32'h00000008;
		#100 edit = 0; din = 0; addr = 0;
	end
	
      initial forever #10 clk = ~clk;
		
endmodule



