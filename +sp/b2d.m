%--------------------------------------------------------------------------
%   [dataout] = b2d(data,N_bit)
%--------------------------------------------------------------------------
%   功能:
%   转换有符号二进制数到10进制数(常用于FPGA测试验证)
%--------------------------------------------------------------------------
%   输入:
%           datain                  二进制数
%           N_bit                   转换位宽
%   output:
%           dataout                 十进制数
%--------------------------------------------------------------------------
%   例子:
%   b2d('1101',5)
%   ans =
%      13
%--------------------------------------------------------------------------
function [dataout] = b2d(datain,N_bit)
dataout = bin2dec(datain);
dataout(dataout>=2^(N_bit-1)) = dataout(dataout>=2^(N_bit-1))-2^N_bit;
end