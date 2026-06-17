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
    output logic [15:0] sdata,    // serial data to PCM5102 DIN
    output logic        bck,      // bit clock to PCM5102 BCK
    output logic        lrck      // word select to PCM5102 LRCK
    );
    
    //localparam int BCLK_DIV   = 35; 
    logic [5:0] blk_rate_cnt = 0;
    
    always_ff @(posedge clk) begin
        if(blk_rate_cnt == 6'd35) begin
            blk_rate_cnt = 0;
            bck = 1'b1;
        end
        blk_rate_cnt = blk_rate_cnt + 1;
        bck = 1'b0;
    end
    
    logic [4:0] ws_cnt = 5'd0;
    
    always_ff @(posedge clk) begin 
            if(ws_cnt == 5'd15) begin
                lrck <= 1'b1;
                ws_cnt <= ws_cnt + 1;
            end
            else if (ws_cnt == 5'd31) begin
                lrck <= 1'b0;
                ws_cnt <= 5'd0;
            end
            else begin
                ws_cnt = ws_cnt + 1;
            end
    end
    
    always_ff @(posedge clk) begin
        if(bck) begin
             sdata = data_in[15:14];
        end
    end
    
endmodule
