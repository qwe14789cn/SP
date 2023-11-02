%--------------------------------------------------------------------------
%   wave = lfm_wave(T,B,fs)
%--------------------------------------------------------------------------
%   功能：
%   线性调频信号生成工具
%--------------------------------------------------------------------------
%   输入：
%           T                   信号持续时间
%           B                   信号带宽
%           fs                  信号采样速率
%   输出：
%           wave                宽带信号波形
%--------------------------------------------------------------------------
%   例子：
%   sig = lfm_wave(1e-4,50e6,100e6)
%--------------------------------------------------------------------------
function wave = lfm_wave(T,B,fs)
delta_T = 1/fs;
t_axis = (-T/2:delta_T:T/2-delta_T)';
mu = 2*pi*B/T;
wave = exp(1j.*1/2*mu.*t_axis.^2);
end