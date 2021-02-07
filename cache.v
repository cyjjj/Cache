`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:29:06 01/16/2021 
// Design Name: 
// Module Name:    cache 
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
module cache (
	input wire clk,  // clock
	input wire rst,  // reset
	input wire [ADDR_BITS-1:0] addr,  // address
	input wire store,  // set valid to 1 and reset dirty to 0
	input wire edit,  // set dirty to 1
	input wire invalid,  // reset valid to 0
	input wire [WORD_BITS-1:0] din,  // data write in
	output wire hit,  // hit or not
	output reg [WORD_BITS-1:0] dout,  // data read out
	output reg valid,  // valid bit
	output reg dirty,  // dirty bit
	output reg [TAG_BITS-1:0] tag  // tag bits
	);

	parameter
		TAG_BITS = 22,
		LINE_WORDS = 4,
		LINE_WORDS_WIDTH = 2; // word offset
	localparam
		ADDR_BITS = 32,
		WORD_BYTES = 4; // 1 word = 4 bytes
	localparam
		WORD_BITS = 8 * WORD_BYTES,  // 1 byte = 8 bits
		WORD_BYTES_WIDTH = 2, // byte offset
		LINE_INDEX_WIDTH = ADDR_BITS - TAG_BITS - LINE_WORDS_WIDTH - WORD_BYTES_WIDTH,  // index: 6 bits
		LINE_NUM = 1 << LINE_INDEX_WIDTH;  // 2^6 = 64
	
	// Cache Line Memory
	reg [LINE_NUM-1:0] inner_valid = 0;
	reg [LINE_NUM-1:0] inner_dirty = 0;
	reg [TAG_BITS-1:0] inner_tag [0:LINE_NUM-1];
	reg [WORD_BITS-1:0] inner_data [0:LINE_NUM*LINE_WORDS-1];
	
	// Read and Write Cache
	always @(negedge clk) begin // 按word为单位读/写
		dout <= inner_data[addr[ADDR_BITS-TAG_BITS-1:WORD_BYTES_WIDTH]];
		if (store || (edit && hit))
			inner_data[addr[ADDR_BITS-TAG_BITS-1:WORD_BYTES_WIDTH]] <= din;
	end
	
	// Dirty, Valid, tag of Cache
	// index: addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]
	always @(negedge clk) begin
		if (rst) begin
			inner_valid <= 0;
			inner_dirty <= 0;
		end
		else if (invalid) begin
			inner_valid[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]] <= 0;
			inner_dirty[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]] <= 0;
		end
		else if (store) begin // read in data 
			inner_valid[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]] <= 1;
			inner_dirty[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]] <= 0;
			inner_tag[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]] <= addr[ADDR_BITS-1:ADDR_BITS-TAG_BITS];
		end
		else if (edit) begin // write the data
			inner_dirty[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]] <= 1;
			inner_tag[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]] <= addr[ADDR_BITS-1:ADDR_BITS-TAG_BITS];
		end
	end
	
	// output of Dirty, Valid, tag, hit
	always @(negedge clk) begin
		valid <= inner_valid[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]];
		dirty <= inner_dirty[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]];
		tag <= inner_tag[addr[ADDR_BITS-TAG_BITS-1:LINE_WORDS_WIDTH+WORD_BYTES_WIDTH]];
	end
	
	assign hit = valid & (tag == addr[ADDR_BITS-1:ADDR_BITS-TAG_BITS]);
	
endmodule
