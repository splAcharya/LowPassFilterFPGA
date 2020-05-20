`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2019 06:57:28 PM
// Design Name: 
// Module Name: clk_desired
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


module clk_desired(
input clk_100MHz,
input reset,
output reg clk_desired 
    );
    
parameter periodVal = 1000;    //1000 kHz
reg [31:0]counter;   
always @ (posedge clk_100MHz, posedge reset)    
begin
    if(reset)
    begin
        counter <= 0;
    end
    else if(counter < periodVal)
    begin
        counter <= counter + 1;
    end
    else
    begin
        counter <= 0;
        clk_desired <= ~ clk_desired;
    end
end
    
endmodule
