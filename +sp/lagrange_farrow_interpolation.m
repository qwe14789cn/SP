%--------------------------------------------------------------------------
%   [y_interp,index] = lagrange_farrow_interpolation(Sig_in,fs_in,fs_out,order)
%--------------------------------------------------------------------------
%   功能：
%   farrow滤波器信号重采样
%--------------------------------------------------------------------------
%   输入:
%           Sig_in           输入信号
%           fs_in            对应输入信号采样率
%           fs_out           输出采样率
%           order            阶数
%   输出:
%           y_interp         对应插值时间轴的信号
%           index            插值整数 → 插值后的整数,小数
%--------------------------------------------------------------------------
function [Sig_out,index] = lagrange_farrow_interpolation(Sig_in,fs_in,fs_out,order)
Sig_in = Sig_in(:);
%初始化拉格朗日插值滤波器系数
h = lagrange_farrow_matrix(order);

if rem(order,2) == 1
    disp('奇数阶数')
else
    disp('不允许输入偶数')
    return
end

delay_Point = floor(order/2);
delta = fs_in/fs_out;                                                       %计算步进整数差
%   必须提前算
time_axis_out = 0:delta:numel(Sig_in) - delta;                              %提前算好整数延迟点

%   插值后的计算整数和小数部分
Integer_Part = floor(time_axis_out);
Fractional_Part = time_axis_out - Integer_Part;

%   计算插值前后 转换表
if nargout == 2
for idx = 0:max(Integer_Part)
    index(idx+1,:) = {idx,Integer_Part(Integer_Part == idx),Fractional_Part(Integer_Part == idx)};
end
end
Sig_out = zeros(numel(time_axis_out),1);

for idx = 1:numel(time_axis_out)

    %   开始数据不够 补0
    if Integer_Part(idx) < delay_Point
        Sig_out(idx,:) = 0;
        continue
    end

    %   尾巴数据没了 补0
    if Integer_Part(idx)>= length(Sig_in) - delay_Point %奇数
        Sig_out(idx,:) = 0;
        continue
    end
    %----------------------------------------------------------------------
    %   farrow滤波器卷积
    %----------------------------------------------------------------------
    F_out = h * Sig_in(Integer_Part(idx)-delay_Point+1:Integer_Part(idx)+delay_Point+1); %奇数
    Sig_out(idx,:) = Fractional_Part(idx).^((order-1):-1:0) * F_out;
end







function h = lagrange_farrow_matrix(L)
N = L-1;                                                                    % 滤波器阶数
M = N/2;                                                                    % 中心值
%--------------------------------------------------------------------------
if (M-round(M))==0 
    N1 = M;
    N2 = M;
else
    N1 = round(M);
    N2 = round(M)-1;
end

P = [];
for k = -N1:N2
    poly_para = 1;
    poly_gain = 1;
    for m = -N1:N2
        if m ~= k
            poly_para = conv(poly_para,[-m -1]);
            poly_gain = poly_gain*(k-m);
        end
    end
    P = [P;poly_para./poly_gain];
end
h = rot90(P,2).';
end

end
