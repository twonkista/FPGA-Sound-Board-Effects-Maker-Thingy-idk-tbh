`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2026 08:39:33 AM
// Design Name: 
// Module Name: bram_controller
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
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_controller(
    input clk,
    input logic [7:0] key_board_in,
    input data_valid_in,
    input pitch_sel, //new input
    output logic [15:0] hex_16
    );
    
    logic [11:0] sample_rate_cnt;
    logic [14:0] bram_addr;
    logic [15:0] empty_vec = 16'd0;
    logic [2:0] sel;
    
    assign sel = key_board_in[2:0]; 
    
    
    logic address_reset;
    always_ff @(posedge clk) begin
        if (data_valid_in) begin
            address_reset <= 1'b1; // Pulse high for exactly 1 cycle
        end else begin
            address_reset <= 1'b0; // Immediately drop back to low
        end
    end
    
    logic [11:0] sample_rate; //sample rate calculator here
    always_comb begin
        if(pitch_sel) begin
            sample_rate = 12'h46E;
        end
        else begin
            sample_rate = 12'h8DB;
        end
    end
    
    logic playback;
    logic [15:0] sample_length = 15'h56D8;
    
    always_ff @(posedge clk) begin
        if (address_reset) begin
            sample_rate_cnt <= 0; 
            bram_addr <= 0;
            playback <= 1'b1;
        end
        else if (playback) begin
            if (bram_addr == sample_length) begin
                playback <= 1'b0;
            end
            else if (sample_rate_cnt == sample_rate) begin //modified variable here
                sample_rate_cnt <= 0;
                bram_addr <= bram_addr + 1;
            end 
            else begin
                sample_rate_cnt <= sample_rate_cnt + 1;
            end
       end
    end
   
    logic [15:0] douta_clap,douta_hihat, douta_kick, douta_note;
    blk_mem_gen_0 clap_blk( .clka(clk), .ena(1'b1), .wea(1'b0), .addra(bram_addr), .dina(16'd0), .douta(douta_clap));
    blk_mem_gen_1 hihat_blk( .clka(clk), .ena(1'b1), .wea(1'b0), .addra(bram_addr), .dina(16'd0), .douta(douta_hihat));
    blk_mem_gen_2 kick_blk( .clka(clk), .ena(1'b1), .wea(1'b0), .addra(bram_addr), .dina(16'd0), .douta(douta_kick));
    blk_mem_gen_3 note_blk( .clka(clk), .ena(1'b1), .wea(1'b0), .addra(bram_addr), .dina(16'd0), .douta(douta_note));
    
    logic reset;
    
    always_ff @(posedge clk) begin 
        reset <= 0;
        case (sel)
            3'b001: begin
                reset <= 1; 
                hex_16 <= douta_clap;
            end
            3'b010: begin 
                reset <= 1; 
                hex_16 <= douta_hihat;
            end
            3'b011: begin
                reset <= 1; 
                hex_16 <= douta_kick;
            end
            3'b100: begin
                reset <= 1; 
                hex_16 <= douta_note;
            end
            default: begin
                hex_16 <= 16'd0;       
            end
        endcase
    end   
endmodule