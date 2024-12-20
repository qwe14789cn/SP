%--------------------------------------------------------------------------
%   sig = intermittent_sampling(sig,N_sample)
%--------------------------------------------------------------------------
%   功能：
%   对采集波形按照一定的周期进行间歇采样并转发出去
%--------------------------------------------------------------------------
%   输入：
%           sig         原始信号
%           N_sample    间歇采样(点数) 周期为2*N_sample
%   输出：
%           wave        间歇采样波形输出
%--------------------------------------------------------------------------
%   参考文献：
%   《基于间歇采样的SAR欺骗干扰研究》
%--------------------------------------------------------------------------
%   例子：
%   sig = intermittent_sampling(sig,N)
%--------------------------------------------------------------------------
function wave = intermittent_sampling(sig,N_sample)
arguments(Input)
    sig         (:,1)   double
    N_sample    (1,1)   double = 1
end
arguments(Output)
    wave        (:,1)   double
end

cut_len = [rectwin(N_sample);zeros(N_sample,1)];                            %构造一个采样周期的完整形态
sig_len = numel(sig);                                                       %计算信号总长度
rep_len = ceil(sig_len/N_sample/2);                                         %用ceil除法计算采样周期重复几次
cut_sig = repmat(cut_len,1,rep_len);                                        %矩阵复制得到采样间隔
cut_sig = cut_sig(:);                                                       %矩阵拉平
cut_sig = cut_sig(1:sig_len);                                               %与原来点长一致

wave = sig.*cut_sig;                                                        %间歇采样
end