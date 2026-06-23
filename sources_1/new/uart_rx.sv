`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2026 09:30:59 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx
    (
     input logic rx,
     input logic clk,
     input logic reset,
     output logic data_valid,
     output logic [7:0] data_out
     //output logic [2:0] count,
     //output logic [1:0] state_c
     );
     
     logic [10:0] counter;
     logic [2:0] data_cnt;
     localparam int BAUD_DIV = 867;
     localparam int CNT_DIV = 433;
     
     typedef enum logic [1:0] {
        IDLE,
        START,
        READ,
        STOP
     } state_t;
     
     state_t state, next_state;
     
     logic [7:0] packet_buffer;
     
     always_comb begin
        case (state)
            IDLE: begin
                if(rx == 1'b0) begin
                    next_state = START;
                end
                else begin 
                    next_state = IDLE;
                end
            end
            START: begin
                if(counter == CNT_DIV) begin 
                    next_state = READ;                  
                end
                else begin 
                    next_state = START;
                end
            end
            READ: begin
               next_state = READ;    
            end
            STOP: begin
                if(rx == 1'b1) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = STOP;
                end
            end
        endcase
     end
     
     always_ff @(posedge clk) begin
        if (reset) begin
            data_cnt <= 3'd0;
            counter <= 10'd0;
            packet_buffer <= 8'd0;
            state <= IDLE;
        end
        else begin
            case(state) 
                IDLE: begin
                    state <= next_state;
                    data_cnt <= 3'd0;
                    counter <= 10'd0;
                    data_valid <= 1'b0;
                end
                START: begin 
                    if(next_state == READ) 
                        counter <= 10'd0;
                    else
                        counter <= counter + 1;
                    state <= next_state;
                end
                READ: begin
                    if(counter == (BAUD_DIV - 1)) begin
                        packet_buffer <= {packet_buffer[6:0],rx}; 
                        data_cnt <= data_cnt + 1;
                        counter <= 10'd0;
                        if(data_cnt == 3'd7)
                            state <= STOP;
                    end
                    else begin
                        counter <= counter + 1;
                    end
                end
                STOP: begin
                    state <= next_state;
                    data_valid <= (next_state == IDLE);
                end
            endcase
        end
     end
     
     assign data_out = packet_buffer;
     //assign count = data_cnt;
     //assign state_c = state;
endmodule
