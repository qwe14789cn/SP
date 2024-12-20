%--------------------------------------------------------------------------
%   out = send_msg(M,N)
%--------------------------------------------------------------------------
%   功能：
%   生成通信数据编码
%--------------------------------------------------------------------------
%   输入:
%           M           行数
%           N           列数
%--------------------------------------------------------------------------
%   输出:
%           out         [0 1]随机序列/[-1 1]随机序列
%--------------------------------------------------------------------------
%   例子:
%   send_msg(10,1)
%   send_msg(10,1,'nrz')
%--------------------------------------------------------------------------
function out = send_msg(M,N,type)
out = randi([0 1],M,N);

if nargin <=2
    type = 'default';
end

switch type
    case 'default'
    
    case 'nrz'
        out = 2.*out-1;
end