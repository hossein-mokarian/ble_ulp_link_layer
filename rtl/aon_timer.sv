
module aon_timer (
    input  logic        clk_aon,        // 32 kHz, always on
    input  logic        rst_n,

    input  logic [15:0] interval,       // connection interval in AON ticks
    input  logic        timer_load,     // from PD_CORE after connection setup
    
    output logic        wake_req        // single-cycle pulse to aon_ctrl
);

    logic [15:0] counter;

    always_ff @(posedge clk_aon or negedge rst_n) begin
        if (!rst_n) begin
            counter  <= interval - 1; // Todo: '0
        end else if (timer_load) begin
            counter  <= interval - 1;
        end else if (counter == 16'b0) begin
            counter  <= interval - 1;
        end else begin
            counter  <= counter - 1'b1;
        end
    end

    assign wake_req = (counter == '0);

endmodule
