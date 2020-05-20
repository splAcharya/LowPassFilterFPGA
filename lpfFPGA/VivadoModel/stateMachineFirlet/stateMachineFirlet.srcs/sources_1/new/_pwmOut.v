`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Swapni Acharya
// 
// Create Date: 04/25/2019 01:17:12 PM
// Design Name: 
// Module Name: _pwmOut
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


module _pwmDAC(
input _baseClk,
input _reset,
input [9:0] _maxVoltage,
output reg _pwmOut
    );
    
parameter _samplingRate = 1000;
reg [31:0] _countPeriod;
reg [31:0] _countDutyCycle;
reg temp;
reg _start;
initial _start = 1'b1;

    
always@(posedge _baseClk, posedge _reset)
    begin
        if(_reset)
        begin
            _countPeriod <= 32'b0;
            _countDutyCycle <= 32'b0;
        end
        
        else if( _countPeriod < _samplingRate)
        begin
            _countPeriod <= _countPeriod + 1;
            
            if(_start == 1'b1)
            begin
                if(_countDutyCycle < _maxVoltage )
                begin
                    _countDutyCycle <= _countDutyCycle + 1;
                    _pwmOut <= 1'b1;
                end
                else
                begin
                    _countDutyCycle <= 0;
                    _pwmOut <= 1'b0;
                    _start <= 1'b0;
                end
            end
            else
            begin
                temp <= 1'b1;
            end
        end
        else
        begin
            _countPeriod <= 32'b0;
            _start <= 1'b1;
        end
    end
endmodule
