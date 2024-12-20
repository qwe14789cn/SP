%--------------------------------------------------------------------------
%   [L,L_P,L_dB] = l_norm_array_pattern(theta_d,N,angle_axis,window_handle)
%--------------------------------------------------------------------------
%   功能：
%   一维线阵天线方向图快速绘制
%--------------------------------------------------------------------------
%   输入:
%           theta_d           波束指向角
%           N                 阵元数
%           angle_axis        绘制角度轴
%           window_handle     窗函数句柄
%   输出:
%           L           电磁辐射复数形式
%           L_P         功率天线方向图
%           L_dB        dB天线方向图
%--------------------------------------------------------------------------
%   例子:
%   theta_target_d  = 10;
%   N = 20;
%   [L,L_P,L_dB] = l_norm_array_pattern(3,N,angle_axis)
%   [L,L_P,L_dB] = l_norm_array_pattern(3,N,angle_axis,@hamming)
%--------------------------------------------------------------------------
function [L,L_P,L_dB] = l_norm_array_pattern(theta_target_d,N,angle_axis,window_handle)
if nargin<=3
    window_handle = @rectwin;
end

lambda = 1;
dd = 0.5;
d = 0:dd:(N-1)*dd;                                                          %构建阵列坐标
window = window_handle(N);
w = exp(1j.*2*pi*d.'*sind(theta_target_d)./lambda).*window(:);              %导向矢量
idx = 1;
for theta_step = angle_axis
    A = exp(1j.*2*pi*d.'*sind(theta_step)/lambda);
    % L(idx) = w'*A;                                                          %近似选取上一步作为归一化中心
    L(idx,:) = sum(conj(w).*A,1);
    idx = idx + 1;
end
L = L./max(abs(L));
L_P = abs(L).^2;
L_dB = mag2db(abs(L));