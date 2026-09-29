module datapath (
    input  logic       clk,
    input  logic       reset,
    input  logic       enable,
    input  logic       clear,
    input  logic [7:0] data_in,
    output logic [7:0] result,
    output logic       finished
);

    logic [2:0] count;

    always_ff @(posedge clk) begin
        if (reset)
            count <= 3'b000;
        else if (clear)
            count <= 3'b000;
        else if (enable)
            count <= count + 1;
    end

    // signal that five operations have completed
    assign finished = (count == 3'd5);

    // accumulator
    always_ff @(posedge clk) begin
        if (reset)
            result <= 8'b00000000;
        else if (clear)
            result <= 8'b00000000;
        else if (enable)
            result <= result + data_in;
    end

endmodule