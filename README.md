# SystemVerilog RTL Processing Unit

A small FSM-controlled processing unit designed and verified in SystemVerilog.

## Overview

This project implements a simple processing unit that accepts a sequence of 8-bit input values, accumulates them over five enabled operations, and indicates when the final result is ready.

The design is divided into two main components:

- **Control FSM** — manages the operation sequence and generates control signals.
- **Datapath** — performs the accumulation and tracks the number of operations.

## Architecture

```text
             ┌──────────────┐
 start ─────►│ Control FSM  │
             └──────┬───────┘
                    │
              enable / clear
                    │
                    ▼
             ┌──────────────┐
 data_in ───►│   Datapath  │───► result
             └──────┬───────┘
                    │
                 finished
                    │
                    └────────► Control FSM

                         done ──► output
```

## Design Details

### Control Signals

The control FSM communicates with the datapath using three main control/status signals:

| Signal | Direction | Purpose |
|---|---|---|
| `enable` | Control → Datapath | Allows the datapath to perform an accumulation |
| `clear` | Control → Datapath | Resets the accumulator and operation counter when a new operation starts |
| `finished` | Datapath → Control | Indicates that five accumulation operations have completed |

The `done` output is asserted by the control FSM when the processing unit enters the `DONE` state.

### Datapath

The datapath contains:

- An 8-bit accumulator (`result`)
- A 3-bit operation counter (`count`)
- Logic to detect when five operations have completed

When `enable` is asserted, the datapath performs:

```text
result ← result + data_in
count  ← count + 1
```

After five enabled operations:

```text
count = 5
finished = 1
```

This causes the control FSM to transition from `WORKING` to `DONE`.

### FSM

The control unit uses three states:

| State | Function |
|---|---|
| IDLE | Waits for a start signal |
| WORKING | Enables the datapath to process inputs |
| DONE | Indicates that the result is ready |

The FSM follows:

```text
IDLE → WORKING → DONE → IDLE
```

### Reset and Clear

The design uses a synchronous reset.

- `reset` initializes the FSM and datapath.
- `clear` prepares the datapath for a new calculation without resetting the entire system.

This prevents results and counter state from a previous operation from carrying over into a new operation.

## Verification

The design was simulated using Icarus Verilog and inspected using GTKWave.

Test cases include:

- Accumulation using different input sequences
- Running multiple operations sequentially
- Reset behaviour
- Verification of the `done` signal
- Waveform inspection of FSM and datapath signals

Example calculations:

```text
1 + 3 + 2 + 4 + 6 = 16
2 + 1 + 5 + 3 + 4 = 15
```

All test cases passed during simulation.

## Debugging

The design was verified using a self-checking SystemVerilog testbench.

During initial simulation, the testbench produced:

```text
FAIL: result = 17, done = 0
```

The issue was traced to clock-cycle timing in the testbench. The first input value was changed before the datapath had an enabled clock edge on which to process it.

The testbench stimulus was corrected so that input values remain stable for the clock cycle in which the datapath processes them.

The corrected simulation passed the verification checks.

Waveforms were also inspected using GTKWave to verify:

- FSM state transitions
- `enable` and `clear` timing
- Accumulator updates
- Operation counter behaviour
- `finished` and `done` signals
- Synchronous reset behaviour

This debugging process demonstrated the importance of aligning testbench stimulus with clocked RTL behaviour.

## Tools

- SystemVerilog
- Icarus Verilog
- GTKWave
- Git
- GitHub
