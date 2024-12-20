%--------------------------------------------------------------------------
%   [equ_filter,...
%    equ_filter_r2r,...
%    equ_filter_r2i,...
%    equ_filter_i2r,...
%    equ_filter_i2i] = multi_channel_equ(ref_sig,channel,filter_L)
%--------------------------------------------------------------------------
%   功能:
%   多通道均衡校准，生成复数滤波器系数实现通道均衡
%--------------------------------------------------------------------------
%   输入：
%           ref_sig         参考通道，列向量放置
%           channel         待校准通道，列向量放置
%   输出：  
%           equ_filter      复数滤波器系数
%           equ_filter_r2r  实→实系数
%           equ_filter_r2i  实→虚系数
%           equ_filter_i2r  虚→实系数
%           equ_filter_i2i  虚→虚系数
%--------------------------------------------------------------------------
function [equ_filter,...
          equ_filter_r2r,...
          equ_filter_r2i,...
          equ_filter_i2r,...
          equ_filter_i2i] = multi_channel_equ(ref_sig,channel,filter_N)
if rem(filter_N,2) ~= 1
    disp('滤波器长度必须为奇数')
end

N = floor(filter_N/2);
w_ref = [zeros(N,1);1;zeros(N,1)];                                          %参考通道滤波器
ref_sig = conv(ref_sig,w_ref);                                              %信号
nfft = length(ref_sig);                                                     %fft点数

ref_freq = fft(ref_sig,nfft,1);                                             %参考通道频域
channel_freq = fft(channel,nfft,1);                                         %待校准通道频域

fix_vector = ref_freq./channel_freq;                                        %得到频域校正矢量

A = matrix_ml(nfft,filter_N);                                               %生成频率因子阵

equ_filter = (A'*A)^-1*(A)'*fix_vector;                                     %复数均衡滤波器

equ_filter = [w_ref equ_filter];
equ_filter_r2r =  real(equ_filter);
equ_filter_i2r = -imag(equ_filter);
equ_filter_r2i =  imag(equ_filter);
equ_filter_i2i =  real(equ_filter);
end

function A = matrix_ml(M,L)
[l,m] = meshgrid((0:L-1),(0:M-1));
A = exp(-1j.*2.*pi.*m.*l./M);
end
