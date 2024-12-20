%--------------------------------------------------------------------------
%   [L,th] = left_cfar(sig,shape,k,d)
%--------------------------------------------------------------------------
%   功能：
%   左侧cfar检测器
%--------------------------------------------------------------------------
%   输入：
%           sig                 绝对值后的激光回波
%           shape               左侧恒虚警检测 [门限计算长度，隔离点数]
%           k                   门限缩放值
%           d                   门限直流项
%   输出：
%           L                   逻辑判决结果
%           th                  判决门限
%--------------------------------------------------------------------------
%   例子：
%   L = left_cfar(sig,[8,3],2,0)
%--------------------------------------------------------------------------
function [L,th] = left_cfar(sig,shape,k,d)
noise_L = shape(1);
seprate_L = shape(2);
st = 1+sum(shape);                                                          %门限起始点

for jdx = 1:size(sig,2)                                                     %信号列向量flag
    for idx = st:size(sig,1)                                                %信号按照点索引
        noise = sig(idx-seprate_L-noise_L:idx-seprate_L-1);
        power(idx,jdx) = sum(noise);
    end
end
power(1:sum(shape)) = power(1+sum(shape));
th = power.*k+d;
L = sig>th;