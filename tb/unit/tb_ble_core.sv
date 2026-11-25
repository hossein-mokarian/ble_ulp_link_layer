`timescale 1ns/1ps

module tb_ble_core;

    localparam CRC_SEED = 24'h515555;

    logic         clk;
    logic         rst_n;

    logic         pkt_start;
    logic         pkt_done;
    logic  [6:0]  channel_seed;
    logic         tx_data_bit;
    logic         tx_data_valid;

    logic [15:0] timer_interval;
    logic        timer_load;
    
    logic [23:0]  crc_out;
    logic         whitened_out;

    integer     failures;
    integer     byte_idx;
    integer     bit_idx;

    logic [23:0] crc_value;
    logic fb;


    // Golden vector: raw PDU + CRC (from Bluetooth Core Spec)
    // PDU bits fed LSB-first into CRC
    // logic [215:0] golden_pdu_crc [0:0];  // 27 bytes = 216 bits
    logic [7:0] golden_pdu_crc [0:20];
    // Whitened expected output (from Bluetooth Core Spec)
    logic [7:0] golden_whitened [0:20];


    // DUT: FSM + CRC + whitening
    ble_core_top u_ble_core (
        .clk_core       (clk),
        .rst_n_core     (rst_n),

        .pkt_start      (pkt_start),
        .pkt_done       (pkt_done),
        .whit_seed      (channel_seed),
        .tx_bit         (tx_data_bit),
        .tx_data_valid  (tx_data_valid),
        .rx_bit         (),
        .rx_data_valid  (),

        .timer_interval (timer_interval),
        .timer_load     (timer_load),
        .crc_out        (crc_out),
        .whitened_out   (whitened_out)
    );


    // Clock: 16 MHz (BTLE baseband typical)
    always #31.25 clk = ~clk;


    // Self-check task
    task check;
        input expected;
        input actual;
        input [167:0] label;
        
        begin
            if (actual === expected)
                $display("PASS: %s", label);
            else begin
                $display("FAIL: %s expected=%b got=%b", label, expected, actual);
                failures = failures + 1;
            end
        end
    endtask


    initial begin

        //--- init ---
        failures = 0;
        clk = 0;
        rst_n = 0;
        pkt_start = 0;
        pkt_done = 0;
        tx_data_bit = 0;
        tx_data_valid = 0;
        channel_seed = 7'd38;  // Channel 37 + 1
        byte_idx = 0;
        bit_idx = 0;
        crc_value = CRC_SEED;
        fb = 1'b0;

        // Golden vector: first 27 bytes of PDU+CRC, MSB-first feeding order
        $readmemb("golden_pdu_crc.hex", golden_pdu_crc);
        $readmemb("golden_whitened.hex", golden_whitened);

        //--- reset ---
        repeat(5) @(negedge clk);
        rst_n = 1;
        repeat(5) @(negedge clk);

        // Start packet
        pkt_start = 1;
        @(negedge clk);
        pkt_start = 0;

        crc_value = CRC_SEED;
        fb = 1'b0;

        // Feed 216 bits (PDU 208 bits + CRC 24 bits = 232)
        for (byte_idx = 0; byte_idx < 18; byte_idx++) begin
            for (bit_idx = 7; bit_idx >= 0; bit_idx--) begin
                tx_data_bit = golden_pdu_crc[byte_idx][bit_idx];  // MSB-first feed
                tx_data_valid = 1;
                @(posedge clk);

                $display("++++++++++++++++++++++++++++++++");
                $display("crc_out = %x", crc_out);
                $display("crc_value = %x", crc_value);
                assert (crc_value == crc_out) 
                    else $error("%t, The crc value is not correct. crc_out=%x , crc_value = %x", $time, crc_out, crc_value);

                fb = tx_data_bit ^ crc_value[23];
                crc_value = {crc_value[22:0], 1'b0} ^ (fb ? 24'h00065B : 24'h000000);
            end
        end

        // One cycle latency
        @(posedge clk);
        tx_data_valid = 0;
        @(posedge clk);

        // Self-check CRC
        $display("========================================");
        $display("crc_out = %x", crc_out);
        check(1'b1, (crc_out == 24'h1BC475), "CRC-24 matches golden");

        $display("========================================");
        if (failures == 0)
            $display("ALL TESTS PASSED (0 failures)");
        else
            $display("TEST FAILED: %0d failures", failures);
        $display("========================================");

        $finish;
    end


    initial begin
        $dumpfile("tb_ble_core.vcd");
        $dumpvars(0, tb_ble_core);
    end

endmodule
