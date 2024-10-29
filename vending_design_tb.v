`timescale 1ns / 1ps

module vending_design_tb;

    // Inputs
    reg clk;
    reg reset;
    reg coin;
    reg [1:0] select;

    // Outputs
    wire item_dispense;
    wire refund;

    // Expected outputs for comparison
    reg expected_dispense;
    reg expected_refund;

    // Instantiate the vending_design module
    vending_design uut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .select(select),
        .item_dispense(item_dispense),
        .refund(refund)
    );

    // Clock generation
    always #5 clk = ~clk;  // Clock period = 10 ns

    // Testbench initialization
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        coin = 0;
        select = 2'b00;

        // EPWave generation setup (this may depend on your simulator)
        $dumpfile("vending_design_tb.vcd");  // Set the VCD file name
        $dumpvars(0, vending_design_tb);      // Dump all variables from this module

        #10 reset = 0; // Release reset after 10 ns

        // Test cases as before...

        #100 $finish;  // End simulation
    end

    // Task to check results against expected values
    task check_results;
        begin
            if (item_dispense !== expected_dispense) begin
                $display("Test failed at time %t: Expected item_dispense = %b, got %b", $time, expected_dispense, item_dispense);
            end else begin
                $display("Item dispense test passed at time %t", $time);
            end

            if (refund !== expected_refund) begin
                $display("Test failed at time %t: Expected refund = %b, got %b", $time, expected_refund, refund);
            end else begin
                $display("Refund test passed at time %t", $time);
            end
        end
    endtask

endmodule
