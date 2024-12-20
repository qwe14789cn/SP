%--------------------------------------------------------------------------
%   output = alpha_beta_filter(input,alpha)
%--------------------------------------------------------------------------
%   功能：
%   alpha-beta低通滤波器
%--------------------------------------------------------------------------
%   输入：
%           input               待处理数据列矢量
%           alpha               alpha学习速率
%                               beta = 1-alpha遗忘速率，取值范围[0~1]
%   输出：
%           output              返回滤波后信号
%--------------------------------------------------------------------------
%   例子：
%   out = lt.alpha_beta_filter(input,0.01)
%--------------------------------------------------------------------------
function output = alpha_beta_filter(input,alpha)
if alpha>= 0 && alpha<=1
    beta = 1-alpha;
else
    disp('alpha在[0-1]区间内');
end

output = zeros(size(input));
[M,N] = size(input);
for jdx = 1:N
    temp = input(1,jdx);
    output(1,jdx) = temp;
    for idx = 2:M
        temp = input(idx,jdx).*alpha + temp.*beta;
        output(idx,jdx) = temp;
    end
end