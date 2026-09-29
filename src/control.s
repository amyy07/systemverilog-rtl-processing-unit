module control (
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic finished,
    output logic enable,
    output logic clear,
    output logic done
);

    // fsm states
    typedef enum logic [1:0] {
        IDLE,
        WORKING,
        DONE
    } state_t;

    state_t current_state;
    state_t next_state;

    // fsm state register
    always_ff @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // next-state logic
    always_comb begin
        case (current_state)

            IDLE:
                if (start)
                    next_state = WORKING;
                else
                    next_state = IDLE;

            WORKING:
                if (finished)
                    next_state = DONE;
                else
                    next_state = WORKING;

            DONE:
                next_state = IDLE;

            default:
                next_state = IDLE;

        endcase
    end

    // enable datapath when working
    always_comb begin
    if (current_state == WORKING && finished == 1'b0)
        enable = 1'b1;
    else
        enable = 1'b0;
end

    // done logic
    always_comb begin
        if (current_state == DONE)
            done = 1'b1;
        else
            done = 1'b0;
    end

    // clear datapath for new operation 
    always_comb begin
        if (current_state == IDLE && start == 1'b1)
            clear = 1'b1;
        else
            clear = 1'b0;
    end

endmodule