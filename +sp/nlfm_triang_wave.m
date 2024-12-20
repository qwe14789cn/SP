%--------------------------------------------------------------------------
%   wave = nlfm_triang_wave(T,Am,fm,fs)
%--------------------------------------------------------------------------
%   功能：
%   非线性调频:三角调频信号生成工具
%--------------------------------------------------------------------------
%   输入：
%           T_u                 上升信号持续时间
%           T_d                 下降信号持续时间
%           B                   扫频带宽
%           fs                  生成信号采样率
%   输出：
%           wave                宽带信号波形 Nx1
%--------------------------------------------------------------------------
%   例子：
%   sig = nlfm_triang_wave(20e-6,30e-6,60e6,100e6);
%   figure;spectrogram(sig,128,127,128,100e6,'yaxis');
%--------------------------------------------------------------------------
function wave = nlfm_triang_wave(T_u,T_d,B,fs)
arguments (Input)
    T_u         (1,1)   double = 1
    T_d         (1,1)   double = 1
    B           (1,1)   double = 1
    fs          (1,1)   double = 1
end
arguments (Output)
    wave
end
delta_T = 1/fs;                                                             %采样时间
t_axis_u = (0:delta_T:T_u-delta_T)';                                        %上升时间轴
t_axis_d = (-T_d:delta_T:0-delta_T)';                                       %下降时间轴
mu_u =  2*pi*B/T_u;                                                         %斜率
mu_d = -2*pi*B/T_d;                                                         %斜率
wave_u = exp(1j.*1/2*mu_u.*t_axis_u.^2);                                    %生成扫频
wave_d = exp(1j.*1/2*mu_d.*t_axis_d.^2);                                    %生成扫频
wave = [wave_u;wave_d];
end