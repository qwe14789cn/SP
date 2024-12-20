%--------------------------------------------------------------------------
%   [number_type] = frac_deg2bin(deg_num,order)
%--------------------------------------------------------------------------
%   功能:
%   转换十进制小数到二进制小数，常用于FPGA乘法时候计算二进制加法
%--------------------------------------------------------------------------
%   输入:
%           deg_num                 十进制数
%           order                   保留小数点长度(默认32长)
%
%   输出:
%           bin_num                 二进制小数
%           dec_num                 转换后的十进制数
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
function [bin_num,dec_num] = frac_deg2bin(deg_num,order)
if deg_num<0
    disp('请输入正数')
    bin_num = [];
    dec_num = [];
    return
end

%   如果没有设置位数，默认输出32位小数
if nargin == 1
    order = 32;
end
frac_num = zeros(1,order);
%   迭代表示二进制小数

int_num = floor(deg_num);
rest = deg_num-int_num;

%   根据余数部分表达二进制信息
for idx = 1:order
    if 1/(2^idx)<=rest
        frac_num(idx) = 1;
        rest = rest - 1/(2^idx);
    else
        frac_num(idx) = 0;
    end
    if rest == 0
        break
    end
end
frac_num = frac_num(1:idx);
bin_num = [dec2bin(int_num) '.' char(string(frac_num'))'];
dec_num = 2.^(0:-1:-numel(frac_num))*[int_num frac_num]';
%--------------------------------------------------------------------------
%   字符串插入 格式化
%--------------------------------------------------------------------------
N = length(bin_num); k = fix(N/5);st = 7;
for idx = 1:k-1
    bin_num = insertAfter(bin_num,st,' ');
    st = st+5+1;
end
disp('--------------------------------------------------')
disp(['二进制数为：' bin_num])
disp(['十进制数为: ' num2str(dec_num,['%1.' num2str(order+5) 'f'])])
disp('--------------------------------------------------')
disp(['等效为: x ' num2str(deg_num*2^order) ' / 2^' num2str(order)])
disp('--------------------------------------------------')
disp(['误差为: ' num2str(dec_num-deg_num,['%1.' num2str(order+5) 'f'])])
disp('--------------------------------------------------')
end