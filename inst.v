`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:58 01/16/2021 
// Design Name: 
// Module Name:    inst 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module inst (
	input wire clk,
	input wire rst,
	input wire [3:0] index,  // instruction index
	output wire valid,  // stop running if valid is 0
	output wire write,  // write enable signal for cache
	output wire [31:0] addr  // address for cache
	);
	
	reg [33:0] data [0:7];
	initial begin  // clock cycles are only for reference
		data[0] = 34'h200000004;  // read miss               1+17
		data[1] = 34'h300000018;  // write miss              1+17
		data[2] = 34'h200000008;  // read hit                1
		data[3] = 34'h300000014;  // write hit               1
		data[4] = 34'h210000004;  // read & clean replace    1+17
		data[5] = 34'h310000018;  // write & dirty replace   1+17*2
		data[6] = 34'h310000008;  // write hit               1
		data[7] = 34'h0;          // end              total: 92
	end
	assign
		valid = data[index][33],
		write = data[index][32],
		addr = data[index][31:0];
endmodule

