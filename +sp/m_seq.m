%--------------------------------------------------------------------------
%   [list,seq] = m_seq(coef)
%--------------------------------------------------------------------------
%   功能：
%   m序列生成器，常用于生成伪随机序列，可以与RS编码组合使用进行抗干扰处理
%--------------------------------------------------------------------------
%   输入：
%           coef            反馈级数/反馈系数
%   输出：
%           list            反馈循环系数
%           seq             反馈序列
%--------------------------------------------------------------------------
%   例子：
%   m_seq(4)                            %查询反馈系数
%   m_seq([1 1 0 1])                    %生成反馈系数
%   [list,seq] = m_seq([1 1 0 1])       %反馈系数表，反馈系数二进制值
%--------------------------------------------------------------------------
function [list,seq] = m_seq(coef)
if isscalar(coef)                       %如果数据是一个值 即为级数
    disp('---------------------------------')
    disp([num2str(coef) '级多项式:'])
    output = primpoly(coef,'all');
    disp('反馈系数：')
    disp(b2array(dec2bin(output)))
    disp(['周期:' num2str(2^(coef)-1)])
    disp('---------------------------------')
    return
end

m = numel(coef);
str_data = [];
for idx = 1:m
    if coef(idx) == 1
        str_data = [str_data 'x^' num2str(m-idx) ' + '];
    end
end
str_data = strrep(str_data,'0 + ','0');
disp(['本原多项式: f(x) = ' str_data]);
disp(['连接系数: ' num2str(coef)]); 
disp(['级数: ' num2str(m-1)])
disp(['周期: ' num2str(2^(m-1)-1)])
coef = fliplr(coef);                                                        %计算时将其翻转连接
len = 2^(m-1)-1;                                                              %得到最终生成的m序列的长度                                                                  %对应寄存器运算后的值，放在第一个寄存器
seq = zeros(len, 1);                                                        %给生成的m序列预分配
registers = [ones(1,m-1)]; 
list(1,:) = registers;
seq(1,:) = registers(end);
for idx = 2:len
    backQ = mod(sum(coef(2:end) .* registers),2);                                  %特定寄存器的值进行异或运算，模2加
    registers(2:end) = registers(1:end-1);
    registers(1) = backQ;
    list(idx,:) = registers;
    seq(idx,:) = registers(end);
end
end


function bin_array = b2array(str)
for idx = 1:size(str,1)
    bin_array(idx,:) = logical(str2num(char(str(idx,:))')');
end
end