`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Swapnil Acharya
// 
// Create Date: 04/22/2019 07:38:31 PM
// Design Name: 
// Module Name: _main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module _main(
input clk_100MHz,
input reset,

//switch
input [3:0] sw,

//led
output [15:0]led,

//xadc
input [15:0] vauxp2,
input [15:0] vauxn2,

//sallen key filter
output reg ampPWM,
output ampSD,

//JA pwm out
output reg pwmSig
    );
    
    
 
 wire samplingClk;   //100 kHz
//connect samping clk
clk_desired samplingClock(
.clk_100MHz(clk_100MHz),
.reset(reset),
.clk_desired(samplingClk) 
 );   



//connect xadc
wire [15:0] data_o;
wire ready;
 

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
xadc_wiz_0 xadc_instance_0(
  .di_in(16'b0),              // input wire [15 : 0] di_in
  .daddr_in(7'h12),        // input wire [6 : 0] daddr_in
  .den_in(1'b1),            // input wire den_in
  .dwe_in(1'b0),            // input wire dwe_in
  .drdy_out(ready),        // output wire drdy_out
  .do_out(data_o),            // output wire [15 : 0] do_out
  .dclk_in(clk_100MHz),          // input wire dclk_in
  .reset_in(1'b0),        // input wire reset_in
  .vp_in(0),              // input wire vp_in
  .vn_in(0),              // input wire vn_in
  .vauxp2(vauxp2),            // input wire vauxp2
  .vauxn2(vauxn2),            // input wire vauxn2
  .channel_out(),  // output wire [4 : 0] channel_out
  .eoc_out(),          // output wire eoc_out
  .alarm_out(),      // output wire alarm_out
  .eos_out(),          // output wire eos_out
  .busy_out()        // output wire busy_out
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

//xadc output
wire  [15:0] gateway_in;
assign gateway_in = data_o[15:0]; //ignote last note bitsS
assign led = gateway_in; 




//connect fir compiler 0 .... llow pass
wire fir_ready0;
wire [31:0]fir_out0;
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
fir_compiler_0 fir_instance_0 (
  .aclk(clk_100MHz),                              // input wire aclk
  .s_axis_data_tvalid(ready),  // input wire s_axis_data_tvalid
  .s_axis_data_tready(fir_ready0),  // output wire s_axis_data_tready
  .s_axis_data_tdata(gateway_in),    // input wire [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata(fir_out0)    // output wire [31 : 0] m_axis_data_tdata
);
// INST_TAG_END ------ End INSTANTIATION Template ---------


//pwm out   
wire [9:0] _maxVoltage0;
assign _maxVoltage0[9:0] =  fir_out0[31:22];
wire [9:0] _sampRate0;

wire _pwm1;
_pwmDAC DAC1(
._baseClk(clk_100MHz),
._reset(reset),
._maxVoltage(_maxVoltage0),
._pwmOut(_pwm1)
);




//connect fir compiler 1 .... high pass
wire fir_ready1;
wire [31:0]fir_out1;

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
fir_compiler_1 fir_instance_1 (
  .aclk(clk_100MHz),                              // input wire aclk
  .s_axis_data_tvalid(ready),  // input wire s_axis_data_tvalid
  .s_axis_data_tready(fir_ready1),  // output wire s_axis_data_tready
  .s_axis_data_tdata(gateway_in),    // input wire [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata(fir_out1)    // output wire [31 : 0] m_axis_data_tdata
);
// INST_TAG_END ------ End INSTANTIATION Template --------


//pwm out   
wire [9:0] _maxVoltage1;
assign _maxVoltage1[9:0] =  fir_out1[31:22];

wire _pwm2;
_pwmDAC DAC2(
._baseClk(clk_100MHz),
._reset(reset),
._maxVoltage(_maxVoltage1),
._pwmOut(_pwm2)
);
    
    

assign ampSD = 1'b1; ///enable audio pwm


always@(sw)
begin
    if(sw == 4'b0001)
    begin
        ampPWM <= _pwm1;
        pwmSig <= _pwm1;
    end
    else if(sw == 4'b0011)
    begin
        ampPWM <= _pwm2;
        pwmSig <= _pwm2;
    end
    else
    begin
        ampPWM <= 1'b0;
        pwmSig <= 1'b0;
    end
end

    
endmodule
