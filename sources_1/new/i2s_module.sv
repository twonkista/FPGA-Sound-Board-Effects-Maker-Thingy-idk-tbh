`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2026 01:24:06 PM
// Design Name: 
// Module Name: i2s_module
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


module i2s_module(
    input  logic        clk,      // system clock
    input  logic [15:0] data_in,  // parallel sample from bram_controller
    output logic sdata,    // serial data to PCM5102 DIN
    output logic        bck,      // bit clock to PCM5102 BCK
    output logic        lrck      // word select to PCM5102 LRCK
    );
    
    //localparam int BCLK_DIV   = 35; 
    logic [15:0] shift_reg;
    logic [5:0] blk_rate_cnt = 0;
    
    logic bck_on;
    always_ff @(posedge clk) begin
        if(blk_rate_cnt == 6'd34) begin
            blk_rate_cnt <= 0;
            bck <= 1'b1;
        end
        else begin
            blk_rate_cnt <= blk_rate_cnt + 1;
            bck <= 1'b0;
        end
    end
    
    logic [4:0] ws_cnt = 5'd0;
    
    always_ff @(posedge clk) begin 
        if(bck) begin
            if(ws_cnt == 5'd15) begin
                lrck <= 1'b1;
                ws_cnt <= ws_cnt + 1;
            end
            else if (ws_cnt == 5'd31) begin
                lrck <= 1'b0;
                ws_cnt <= 5'd0;
            end
            else begin
                ws_cnt <= ws_cnt + 1;
            end
        end
    end
    
    always_ff @(posedge clk) begin
        if(bck) begin
            if(ws_cnt == 5'd0 || ws_cnt == 5'd15) begin
                shift_reg <= data_in;
                sdata <= shift_reg[15];
            end
            else begin
                sdata <= shift_reg[15];
                shift_reg <= shift_reg << 1;
            end
        end
    end
    
endmodule
