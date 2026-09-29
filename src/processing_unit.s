module processing_unit (
    input  logic       reset,
    input  logic       clk,
    input  logic       start,
    input  logic [7:0] data_in,
    output logic [7:0] result,
    output logic       done
);

    // control and status signals
    logic enable;
    logic finished;
    logic clear;

    control control_unit (
        .clk(clk),
        .reset(reset),
        .start(start),
        .finished(finished),
        .enable(enable),
        .clear(clear),
        .done(done)
    );

    datapath datapath_unit (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .clear(clear),
        .data_in(data_in),
        .result(result),
        .finished(finished)
    );

endmodule