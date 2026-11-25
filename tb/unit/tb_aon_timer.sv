`timescale 1ns/1ps

module tb_aon_timer;

    logic clk;
    logic rst_n;

    logic [15:0] interval_from_core;
    logic timer_load_from_core;


    aon_timer u_timer (
        .clk_aon    (clk),
        .rst_n      (rst_n),
        .interval   (interval_from_core),   // isolated output of PD_CORE
        .timer_load (timer_load_from_core), // isolated output of PD_CORE
        .wake_req   (wake_req)              // input to PD_CORE, no isolation
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        
        //--- init ---
        interval_from_core = 16'd20;
        timer_load_from_core = 1'b0;

        //--- reset ---
        rst_n = 1'b0;
        repeat(5) @(posedge clk);
        rst_n = 1'b1;
        repeat(5) @(posedge clk);


        //--- Test ---
        while(!wake_req) @(posedge clk);

        repeat(7) @(posedge clk);
        timer_load_from_core = 1'b1;
        @(posedge clk);
        timer_load_from_core = 1'b0;

        while(!wake_req) @(posedge clk);

        #10;

        $finish;

    end

    initial begin
        $dumpfile("tb_aon_timer.vcd");
        $dumpvars(0, tb_aon_timer);
    end

endmodule
