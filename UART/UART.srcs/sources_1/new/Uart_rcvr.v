`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 08:51:50
// Design Name: 
// Module Name: Uart_rcvr
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


module uart_rx(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);
    parameter CLKS_PER_BIT = 868;

    reg [15:0] clk_count;
    reg [3:0] bit_index;
    reg [7:0] rx_shift_reg;
    reg rx_busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_busy <= 0;
            clk_count <= 0;
            bit_index <= 0;
            rx_done <= 0;
            rx_shift_reg <= 0;
        end else begin
            if (!rx_busy && !rx) begin // start bit detected
                rx_busy <= 1;
                clk_count <= CLKS_PER_BIT/2; // sample mid-bit
                bit_index <= 0;
            end else if (rx_busy) begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    if (bit_index < 8) begin
                        rx_shift_reg[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                    end else begin
                        rx_busy <= 0;
                        rx_done <= 1;
                        rx_data <= rx_shift_reg;
                    end
                end
            end else begin
                rx_done <= 0;
            end
        end
    end
endmodule


