module processing_unit_tb;

    logic clk;
    logic reset;
    logic start;
    logic [7:0] data_in;
    logic [7:0] result;
    logic done;

    // instantiate dut
    processing_unit dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .result(result),
        .done(done)
    );

    // generate clock 
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
 
    // waveform
    $dumpfile("processing_unit.vcd");
    $dumpvars(0, processing_unit_tb);

    reset   = 1;
    start   = 0;
    data_in = 0;

    // reset system
    @(posedge clk);
    #1;

    reset = 0;
    start = 1;
    data_in = 1;

    // start operation
    @(posedge clk);
    #1;

    start = 0;

    // first actual operation: 1
    @(posedge clk);
    #1;

    data_in = 3;

    // 3 is added
    @(posedge clk);
    #1;

    data_in = 2;

    // 2 is added
    @(posedge clk);
    #1;

    data_in = 4;

    // 4 is added
    @(posedge clk);
    #1;

    data_in = 6;

    // 6 is added
    @(posedge clk);
    #1;

    // wait for controller to enter DONE
    @(posedge clk);
    #1;

    if (result == 8'd16 && done == 1'b1)
        $display("First test passed! result = %0d, done = %b", result, done);
    else
        $display("First test failed. result = %0d, done = %b", result, done);

// wait for controller to return to IDLE
@(posedge clk);
#1;

// second test
start = 1;
data_in = 2;

// datapath clears stored data
@(posedge clk);
#1;

start = 0;

// 2 is entered
@(posedge clk);
#1;

data_in = 1;

// 1 is added
@(posedge clk);
#1;

data_in = 5;

// 5 is added
@(posedge clk);
#1;

data_in = 3;

// 3 is added
@(posedge clk);
#1;

data_in = 4;

// 4 is added
@(posedge clk);
#1;

// wait for controller to enter DONE
@(posedge clk);
#1;

// run second check
if (result == 8'd15 && done == 1'b1)
    $display("Second test passed! result = %0d, done = %b", result, done);
else
    $display("Second test failed! result = %0d, done = %b", result, done);
// test reset 
reset = 1;

@(posedge clk);
#1;

if (result == 8'd0 && done == 1'b0)
    $display("Reset check passed!: result = %0d, done = %b", result, done);
else
    $display("Reset check failed! result = %0d, done = %b", result, done);

reset = 0;

$finish;

    end

endmodule