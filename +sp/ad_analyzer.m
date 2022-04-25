%--------------------------------------------------------------------------
%   ad_analyzer(sig,fin,fs)
%--------------------------------------------------------------------------
%   功能：
%   ADC性能分析工具（仍然需要完善，功能不全）
%--------------------------------------------------------------------------
%   输入:
%           sig         输入信号
%           fin         测试信号频率
%           fs          采样速率
%	输出：
%           ENOB        有效位
%--------------------------------------------------------------------------
%   例子:
%   ad_analyzer(sig,50e6,250e6)
%--------------------------------------------------------------------------
function ad_analyzer(sig,fin,fs)
N = length(sig);
if mod(fin./fs*N,1)~=0
    Nfft = floor(fin./fs*N)*fs./fin;
    disp("Fin/Fs*信号点数不为整数，会产生频谱泄漏");
    disp(['信号长度由 ' num2str(N) ' 修改为 ' num2str(Nfft) '并做 ' num2str(Nfft) ' 点FFT']);
else
    Nfft = N;
end
if fin>=1e6
    disp("选择坐标Mhz")
    f_x = "MHz";
elseif fin>=1e3
    disp("选择坐标KHz")
    f_x = "KHz";
end

x = 0:fs/Nfft:fs/2 - fs/Nfft;                                               %频率横坐标
f = fft(sig,Nfft);f = f(1:Nfft/2);
a = abs(f);
power = a.^2;                                                               %功率
power_db = pow2db(power);
power_db = power_db - max(power_db(:));                                     %dB

fin_loc = fin./(fs/2)*(Nfft/2)*(0:floor(fs/2/fin))+1;                       %输入信号频点
fin_loc(fin_loc>Nfft/2) = [];                                               %去掉频率范围外面的点

all_power = sum(power);
sig_power = power(fin_loc(1));
noise_power = all_power - sum(power(fin_loc));
snr = sig_power ./noise_power;
snr_db = pow2db(snr);
ENOB = (snr_db - 1.76)/6.02;

figure(1)
if f_x =="KHz"
    x = x./1e3;
elseif f_x =="MHz"
    x = x./1e6;
end
plot(x,power_db,x(fin_loc(2)),power_db(fin_loc(2)),'o')
text(x(fin_loc(2)),power_db(fin_loc(2)),...
    {['Fin = ' num2str(fin./1e6) ' MHz'],['SNR = ' num2str(snr_db) 'dB']})
grid on;
xlabel(f_x);ylabel("dB")
fprintf('信噪比SNR = %1.2f dB,',snr_db);
fprintf('ENOB = %1.2f\n',ENOB);
end




