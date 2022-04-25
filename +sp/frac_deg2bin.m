%--------------------------------------------------------------------------
%   [number_type] = frac_deg2bin(deg_num,order)
%--------------------------------------------------------------------------
%   功能:
%   转换十进制小数到二进制小数，常用于FPGA乘法时候计算二进制加法
%--------------------------------------------------------------------------
%   输入:
%           deg_num                 十进制数
%           order                   保留小数点长度
%
%   输出:
%           number_type             二进制小数
%--------------------------------------------------------------------------
%   例子:
% frac_deg2bin(0.75)
% 二进制小数为：
% ans =
%     '0.11'
% frac_deg2bin(1.75)
% 二进制小数为：
% ans =
%     '1.11'
%--------------------------------------------------------------------------
function [number_type] = frac_deg2bin(deg_num,order)
if deg_num<0
    disp('请输入正数')
    return
end

%   如果没有设置位数，默认输出32位小数
if nargin == 1
    order = 32;
end
bin_num = zeros(1,order);
%   迭代表示二进制小数

int_num = floor(deg_num);
rest = deg_num-int_num;

%   根据余数部分表达二进制信息
for idx = 1:order
    if 1/(2^idx)<=rest
        bin_num(idx) = 1;
        rest = rest - 1/(2^idx);
    else
        bin_num(idx) = 0;
    end
    if rest == 0
        break
    end
end
bin_num = bin_num(1:idx);
number_type = [dec2bin(int_num) '.' char(string(bin_num'))'];
disp('二进制小数为：')
end