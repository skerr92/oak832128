# Welcome to the OAK832128 Repo!
This repo is to store an open source microcontroller that I'm working on as part of a submission to the eFabless MPW-8 shuttle.

The implementation in this repo is currently for a Lattice ICE5LP4K. The MPW-8 Submission will be in a separate repo and will be linked here.

### Nomeclature ###

Microcontroller/CPU designs will have the following structure to make it easy to know the specs:
| Company     | Memory Bit Width | RAM Bytes | FLASH  Bytes | Current Repo? |
|-------------|------------------|-----------|--------------|---------------|
| Oak dev tech| 8 bits           | 32 Bytes  | 128 Bytes    |  Yes          |

The company will always be OAK for any designs I make. If you branch and decide to use this as a base, please update the company name.

The starting number will either be an `8`, `1`, `3`, or a `6' to denote `8 bit`, `16 bit`, `32 bit`, or `64 bit` respectively. `6` is reserved for CPU devices only.
CPUs and MCU can all start with `8`, `1`, and `32`.

### Instruction Set ###

This current implementation on the ICE5LP4K is meant to be driven with an external controller that can deliver 16 bits to the IO for the instruction.

|   OPCodes  | Meaning | Additional inputs  |
|------------|---------|--------------------|
|   4'b0000  | NOP     | NONE               |
|   4'b0001  | LOAD    | 4'b SRC REG        |
|   4'b0010  | STORE   | 4'b REG 8'b VAL    |
|   4'b0011  | ADD     | 2x 4'b SRC 4'b DST |
|   4'b0100  | SUB     | 2x 4'b SRC 4'b DST |
|   4'b0101  | AND     | 2x 4'b SRC 4'b DST |
|   4'b0110  | OR      | 2x 4'b SRC 4'b DST |
|   4'b0111  | MOVE    | 4'b SRC 4'b DST    |
|   4'b1001  | LOAD RAM| 5'b RAM SRC 4'b DST| 
|   4'b1010  | STRE RAM| 4'b SRC 5'b RAM DST|
|   4'b1011  | LOAD FLS| 6'b FLS SRC 4'b DST|
|   4'b1100  | STRE FLS| 4'b SRC 6'b FLS DST|
|   4'b1101  | JMP     | 8'b PC Location    |
|   4'b1110  | JNE     | 8'b PC Location    |
|   4'b1111  | JEQ     | 8'b PC Location    |

Additional details are coming soon include system block diagram!
