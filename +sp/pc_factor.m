%--------------------------------------------------------------------------
%   pcf = pc_factor(temple_sig,bw_range,fs,Nfft,window_fun)
%--------------------------------------------------------------------------
%   功能：
%   频域加窗生成脉冲压缩频域因子，对时域压缩后的效果进行整形，压低副瓣
%   类似nlm_wave函数，同为加窗压副瓣
%--------------------------------------------------------------------------
%   输入：
%           temple_sig          模板信号
%           bw_range            信号带宽
%           fs                  生成信号的采样速率
%           Nfft                做脉压因子的点数
%           window_fun          窗函数默认用chebwin
%   输出：
%           pc_f                频域脉压信号模板
%--------------------------------------------------------------------------
%   例子：
%   waveform = phased.FMCWWaveform('SweepTime',T,'SweepBandwidth',bw,...
%              'SampleRate',fs,'SweepInterval','Symmetric');
%   sig = step(waveform);
%   pc_factor(sig,[-5e6 5e6],fs,Nfft);
%   或者
%   pc_factor(sig,[-5e6 5e6],fs,Nfft,@(x)chebwin(x,100))
%--------------------------------------------------------------------------
function pc_f = pc_factor(temple_sig,bw_range,fs,Nfft,window_fun)
if isreal(temple_sig)
    disp('sig必须为复信号');
    pc_f = nan;
    return
end
if nargin <=4
    window_fun = @(x)chebwin(x,100);                                        %不传递参数采用默认切比雪夫窗
end
bw_low = min(bw_range);                                                     %信号起始带宽
bw_max = max(bw_range);                                                     %信号结束带宽
bw = bw_max-bw_low;                                                         %信号带宽范围
N = round(bw/fs*Nfft);                                                      %占用fft点数的范围区间
window_f = [window_fun(N);zeros(Nfft-N,1)];                                 %生成频域加窗序列
shift_point = round(bw_low/fs*Nfft);                                        %计算窗函数移动点数
window_f = circshift(window_f,shift_point);                                 %新的频域窗
pc_f = window_f./fft(temple_sig,Nfft);                                      %实数除以复数刚好是共轭










