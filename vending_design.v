`timescale 1ns / 1ps

module vending_design (
    input clk,
    input reset,
    input coin,
    input [1:0] select,
    output reg item_dispense,
    output reg refund
);
    reg [7:0] balance;

    parameter PRICE_A = 10;
    parameter PRICE_B = 15;
    parameter PRICE_C = 20;
    parameter PRICE_D = 25;

    reg [1:0] state, next_state;

    localparam IDLE = 2'b00;
    localparam CHECK_BALANCE = 2'b01;
    localparam DISPENSE = 2'b10;
    localparam REFUND = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            balance <= 0;
            item_dispense <= 0;
            refund <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        item_dispense = 0;
        refund = 0;

        case (state)
            IDLE: begin
                if (coin) begin
                    balance <= balance + 5; // Add 5 units per coin
                    next_state = CHECK_BALANCE;
                end
            end

            CHECK_BALANCE: begin
                case (select)
                    2'b00: if (balance >= PRICE_A) next_state = DISPENSE;
                    2'b01: if (balance >= PRICE_B) next_state = DISPENSE;
                    2'b10: if (balance >= PRICE_C) next_state = DISPENSE;
                    2'b11: if (balance >= PRICE_D) next_state = DISPENSE;
                    default: next_state = REFUND;
                endcase
            end

            DISPENSE: begin
                case (select)
                    2'b00: balance <= balance - PRICE_A;
                    2'b01: balance <= balance - PRICE_B;
                    2'b10: balance <= balance - PRICE_C;
                    2'b11: balance <= balance - PRICE_D;
                endcase
                item_dispense <= 1;
                next_state <= IDLE;
            end

            REFUND: begin
                refund <= 1;
                balance <= 0; // Return the remaining balance
                next_state <= IDLE;
            end
        endcase
    end

endmodule
