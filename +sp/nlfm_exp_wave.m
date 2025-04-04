%--------------------------------------------------------------------------
%   wave = nlfm_exp_wave(T,Am,fm,fs)
%--------------------------------------------------------------------------
%   功能：
%   非线性调频:正弦调频信号生成工具
%--------------------------------------------------------------------------
%   输入：
%           T                   信号持续时间
%           Am                  正弦频域振幅
%           fm                  正弦频率
%           fs                  生成信号采样率
%   输出：
%           wave                宽带信号波形 列向量Nx1
%--------------------------------------------------------------------------
%   例子：
%   sig = nlfm_exp_wave(100e-6,60e6,40e3,fs);
%   spectrogram(sig,128,127,128,fs,'yaxis');
%--------------------------------------------------------------------------
function wave = nlfm_exp_wave(T,Am,fm,fs)
arguments (Input)
    T       (1,1)   double = 1
    Am      (1,1)   double = 1
    fm      (1,1)   double = 1
    fs      (1,1)   double = 1
end
arguments (Output)
    wave    (:,1)   double 
end
delta_T = 1/fs;                                                             %采样时间
t_axis = (0:delta_T:T-delta_T)';                                            %时间轴
wave = exp(1j.*(Am/fm.*sin(2*pi*fm*t_axis)));                               %波形
end