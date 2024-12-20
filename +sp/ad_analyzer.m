%--------------------------------------------------------------------------
%   ad_analyzer(sig,fs,N_bits)
%--------------------------------------------------------------------------
%   功能：
%   ADC性能分析工具
%--------------------------------------------------------------------------
%   输入:
%           sig         输入信号
%           fs          采样速率
%           N_bits      ADC位宽  
%--------------------------------------------------------------------------
%   例子:
%   ad_analyzer(sig,fs,N_bits)
%--------------------------------------------------------------------------
function ad_analyzer(sig,fs,N_bits)
sig = sig(:);
len = length(sig);
T = 1/fs;
t_axis = (0:(len-1)).*T;
[T_axis, fscale, xunits] =engunits(t_axis);


rawsig = sig(:);
sig = rawsig/2^(N_bits-1);

% rmsSig = rms(sig);
% rmsSigDBFS = mag2db(rmsSig);
p2pSig = (max(sig)-min(sig))/2;
p2pSigDBFS = mag2db(p2pSig);


[SNR,Noisepow] = snr(sig,fs);
[SFDR,spurpow,spurfreq] = sfdr(sig,fs);
[THD,harmpow,harmfreq] = thd(sig,fs);thdPercent = db2pow(THD)*100;
[SINAD,totdistpow] = sinad(sig,fs);
ENOB = (SINAD-1.76 - p2pSigDBFS) / 6.02;
f = figure(1);
f.Position = get(0,'ScreenSize');
subplot(3,2,[1 2]);
plot(T_axis,rawsig);grid on;xlabel(['时间/' xunits 's']);ylabel('幅度')
ylim([min(rawsig)-eps max(rawsig)+eps].*1.2)

subplot(323);snr(sig,fs);
subplot(324);sfdr(sig,fs);
subplot(325);thd(sig,fs);
subplot(326);sinad(sig,fs);

disp('--------------------------------------------------------------------')
fprintf(['\tADC位数\t\t\tNOB\t\t\t= ' num2str(N_bits) '\t\tBits\n\n']);
fprintf(['\t满量程\t\t\tMaxScale\t= ' num2str(2^(N_bits-1)-1) '\n']);
fprintf(['\t\t\t\t\tMinScale\t= ' num2str(-2^(N_bits-1)) '\n\n']);
fprintf(['\t信号峰峰值\t\tMaxPeak\t\t= ' num2str(max(rawsig)) '\n']);
fprintf(['\t\t\t\t\tMinPeak\t\t= ' num2str(min(rawsig)) '\n']);
fprintf(['\t峰峰值占比\t\tPP Scale\t= ' num2str(p2pSig*100) '%%\t\t\t' num2str(p2pSigDBFS) '\tdBFS\n\n']);
fprintf(['\t信号频率\t\t\tSig freq\t= ' num2str(harmfreq(1)) '\tHz\n']);
disp('--------------------------------------------------------------------')
fprintf(['\t信噪比\t\t\tSNR \t\t= ' num2str(SNR) '\tdB\n']);
fprintf(['\t无杂散动态范围\t\tSFDR\t\t= ' num2str(SFDR) '\tdB\n']);
fprintf(['\t总谐波失真\t\tTHD\t\t\t= ' num2str(THD) '\tdBc\t\t' num2str(thdPercent) '%%\n']);
fprintf(['\t信噪比和失真\t\tSINAD\t\t= ' num2str(SINAD) '\tdBc\n']);
fprintf(['\t有效位数\t\t\tENOB\t\t= ' num2str(ENOB) '\tBits\n']);
disp('--------------------------------------------------------------------')
fprintf(['\t噪声功率\t\t\tNoisePower\t= ' num2str(Noisepow) '\tdB\n\n']);

fprintf(['\t最大杂散功率\t\tSpurPower\t= ' num2str(spurpow) '\tdB\n']);
fprintf(['\t最大杂散频率\t\tSpurFreq\t= ' num2str(spurfreq) '\tHz\n\n']);

T = table((2:length(harmfreq))',harmfreq(2:end),harmpow(2:end));
T.Properties.VariableNames = {'序号','谐波频率(Hz)','谐波功率(dB)'};
disp(T)

fprintf(['\t噪声+谐波总功率\tNoise+harm\t= ' num2str(totdistpow') '\tdB\n']);
disp('--------------------------------------------------------------------')


