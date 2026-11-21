
module pkt_buffer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wr_en,
    input  logic [7:0]  wr_data,
    input  logic        rd_en,
    output logic [7:0]  rd_data,
    output logic        full,
    output logic        empty
);

    logic [7:0] mem [0:3];
    logic [1:0] wr_ptr, rd_ptr;
    logic [2:0] count;

    // Write pointer: enabled by wr_en only
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 2'b00;
            count  <= 3'd0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= wr_data;
            wr_ptr      <= wr_ptr + 1'b1;
            count       <= count + 1'b1;
        end else if (rd_en && !empty) begin
            count <= count - 1'b1;
        end
    end

    // Read pointer: enabled by rd_en only
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rd_ptr <= 2'b00;
        else if (rd_en && !empty)
            rd_ptr <= rd_ptr + 1'b1;
    end

    assign rd_data = mem[rd_ptr];
    assign full    = (count == 3'd4);
    assign empty   = (count == 3'd0);

endmodule
