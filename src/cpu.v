module top(dout, frame,
  LED_R, LED_G, LED_B, LED);

wire [2:0] leds;
input [16:0] frame;
output LED_R, LED_G, LED_B, LED;
output [7:0] dout;
reg [7:0] dout;
reg [3:0] instruction = 4'hF;
reg [7:0] pc = 8'hFF;

reg reset = 0;

reg [7:0] regfile [0:15];
reg [7:0] mem [0:31]/* synthesis syn_ramstyle = "rw_check"*/ ;
reg [7:0] flash [0:127]/* synthesis syn_rmstyle = "rw_check"*/;

initial begin
  $readmemh("../reg.ini",regfile);
  $readmemh("../ram.ini",mem);
  $readmemh("../flash.ini",flash);
end
SB_IO_OD #(             // open drain IP instance
.PIN_TYPE(6'b011001)  // configure as output
) pin_out_driver (
.PACKAGEPIN(LED_B), // connect to this pin
.DOUT0(leds[0])           // output the state of "led"
);

SB_IO_OD #(             // open drain IP instance
.PIN_TYPE(6'b011001)  // configure as output
) pin_out_driver2 (
.PACKAGEPIN(LED_G), // connect to this pin
.DOUT0(leds[1])           // output the state of "led"
);

SB_IO_OD #(             // open drain IP instance
.PIN_TYPE(6'b011001)  // configure as output
) pin_out_driver3 (
.PACKAGEPIN(LED_R), // connect to this pin
.DOUT0(leds[2])           // output the state of "led"
);

wire sysclk;

SB_HFOSC #(.CLKHF_DIV("0b00")) osc (
.CLKHFEN(1'b1),
.CLKHFPU(1'b1),
.CLKHF(sysclk) 
) /* synthesis ROUTE_THROUGH_FABRIC = 0 */;

assign leds  = {~instruction[2:0]};
assign LED = {~instruction[3]};
integer i;
always @(posedge sysclk)
begin
  pc <= pc + 1;
  if (reset == 1) begin
    for (i = 0; i < 16; i = i + 1)
    begin
       regfile [(i)] <= 8'h00;
    end
    instruction = 4'h0;
    pc <= 8'h0;
  end
  instruction = frame[16:13];
  case(instruction)
    4'h0: dout <= 8'h00;// NOP
    4'h1: // LOAD from register file instruction
    begin
      dout <= regfile[frame[12:9]];
    end
    4'h2: // STORE
    begin
      regfile[frame[12:9]] <= frame[8:5];
      dout <= regfile[frame[12:9]];
    end
    4'h3: // ADD two inputs
    begin//  store in regfile   Out Reg A        +      Out Reg B
      regfile[frame[4:1]] <= regfile[frame[12:9]] + regfile[frame[8:5]];
      dout <= regfile[frame[4:1]];
    end
    4'h4: // SUB subtract two inputs
    begin //  store in regfile   Out Reg A       -      Out Reg B
      regfile[frame[4:1]] <= regfile[frame[12:9]] - regfile[frame[8:5]];
      dout <= regfile[frame[4:1]];
    end
    4'h5: // AND two inputs
    begin//  store in regfile   Out Reg A        &      Out Reg B
      regfile[frame[4:1]] <= regfile[frame[12:9]] - regfile[frame[8:5]];
      dout <= regfile[frame[4:1]];
    end
    4'h6: // OR two inputs
    begin //  store in regfile   Out Reg A       |      Out Reg B
      regfile[frame[4:1]] <= regfile[frame[12:9]] - regfile[frame[8:5]];
      dout <= regfile[frame[4:1]];
    end
    4'h7: // MOV two inputs
    begin // Moves into B from A
      regfile[frame[12:9]] <= regfile[frame[8:5]];
      dout <= regfile[frame[12:9]];
    end
    4'h8: // SRAM LOAD
    begin // load into A
      regfile[frame[12:9]] <= mem[frame[8:4]];
      dout <= mem[frame[8:4]];
    end
    4'h9: // SRAM STORE
    begin
      mem[frame[12:8]] <= regfile[frame[7:4]];
      dout <= mem[frame[12:8]];
    end
    4'hA: // FLASH LOAD
    begin
      regfile[frame[12:9]] <= flash[frame[8:2]];
      dout <= flash[frame[8:2]];
    end
    4'hB: // FLASH STORE
    begin
      flash[frame[12:6]] <= regfile[frame[5:2]];
      dout <= flash[frame[12:6]];
    end
    4'hC: // JMP JUMP
    begin
      pc <= frame[12:5];
      dout <= pc;
    end
    4'hD: // JNE 
    begin
      pc <= frame[12:5];
      dout <= pc;
    end
    4'hE: // JEQ
    begin
      pc <= frame[12:5];
      dout <= pc;
    end
    default: // INVALID
      dout <= 8'h00;
  endcase
  
end


endmodule
