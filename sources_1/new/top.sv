`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2026 10:57:07 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// this chooses the specific audio sample of the drum pad
//////////////////////////////////////////////////////////////////////////////////


module top(
    input reset,
    input rx,
    input clk,
    //input [15:0] data_in,
    //input echo,
    input bit_crush,
    input volume,
    input pitch_sel,
    output sdata,
    output bck,
    output lrck
);

    logic data_valid;
    logic [7:0] key_out;
    uart_rx recive_input (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(key_out),
        .data_valid(data_valid)
    );
    
    logic [15:0] formula_out;
    logic [15:0] sound_sample;
    
    bram_controller controller_keyb(
        .clk(clk),
        .key_board_in(key_out),
        .pitch_sel(pitch_sel),
        .data_valid_in(data_valid),
        .hex_16(sound_sample)
    );
    
    logic [15:0] edited_sample;
    
    audio sample_edit(
        .clk(clk),
        .data_in(sound_sample),
        .volume(volume),
        .bit_crush(bit_crush),
        .formula_out(edited_sample)
    );

    i2s_module sample_transmit(
        .clk(clk),
        .data_in(edited_sample),
        .sdata(sdata),
        .bck(bck),
        .lrck(lrck)
        
    );

endmodule
