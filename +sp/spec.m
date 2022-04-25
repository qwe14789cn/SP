%--------------------------------------------------------------------------
%   spec(sig,fs,Nfft,select)
%--------------------------------------------------------------------------
%   功能：
%   信号频谱分析工具，用于分析信号的幅频响应，相频响应，幅相响应
%--------------------------------------------------------------------------
%   输入：
%           sig             原始信号
%           fs              采样速率
%           Nfft            fft点数
%           select          选择点输出相位值       
%--------------------------------------------------------------------------
%   例子：
%   spec(sig,fs)                    不指定fft点数
%   spec(sig,fs,nfft)               指定fft点数
%   spec(sig,fs,nfft,select)        输出指定点数相位值
%--------------------------------------------------------------------------
function spec(sig,fs,Nfft,select)
if nargin <=2
    N2 = nextpow2(length(sig));
    Nfft = 2^N2;
end
disp(['信号长度为 -> ' num2str(numel(sig)) ' FFT点数为 -> ' num2str(Nfft)]);
f1 = figure(1);
f1.Position = [95 450 1671 494];
if isreal(sig)==1                                                           %实信号分析，单边功率谱
    f = linspace(0,fs/2-fs/Nfft,Nfft/2);
    A = fft(sig,Nfft);
    A = A(1:Nfft/2);
    subplot(231);plot(f,pow2db(abs(A).^2));
    xlabel('频率 hz');ylabel('幅度 dB');grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 实信号幅频响应'])

    subplot(232);plot(pow2db(abs(A).^2));
    xlabel('点数');ylabel('幅度 dB');grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 实信号幅频响应'])

    subplot(234);plot(f,rad2deg(angle(A)));
    xlabel('频率 hz');ylabel('相位 °');ylim([-180 180]);grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 实信号相频响应'])

    subplot(235);plot(rad2deg(angle(A)));
    xlabel('点数');ylabel('相位 °');ylim([-180 180]);grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 实信号相频响应'])

    subplot(133);
    plot3(1:length(A),real(A),imag(A));grid on
    xlabel('点数');ylabel('实部');zlabel('虚部')
    axis([0 length(A) -max(abs(A)) max(abs(A)) -max(abs(A)) max(abs(A))])
    %----------------------------------------------------------------------
    if nargin <=3                                                           %如果不输入 自动寻找最大值
        select = find(A==max(A));
        ang = rad2deg(angle(A(select)));
    end
    if nargin ==4                                                           %如果不输入 自动寻找最大值
        ang = rad2deg(angle(A(select)));
    end
    title(['点 ' num2str(select) ' 相位为 ' num2str(ang) ' °']);
    %----------------------------------------------------------------------
else                                                                        %复信号分析，单边功率谱
    f = linspace(0,fs-fs/Nfft,Nfft);
    A = fft(sig,Nfft);
    subplot(231);plot(f,pow2db(abs(A).^2));
    xlabel('频率 hz');ylabel('幅度 dB');grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 复信号幅频响应'])

    subplot(232);plot(pow2db(abs(A).^2));
    xlabel('点数');ylabel('幅度 dB');grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 信号幅频响应'])

    subplot(234);plot(f,rad2deg(angle(A)));
    xlabel('频率 hz');ylabel('相位 °');ylim([-180 180]);grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 实信号相频响应'])

    subplot(235);plot(rad2deg(angle(A)));
    xlabel('点数');ylabel('相位 °');ylim([-180 180]);grid on
    title(['采样速率' num2str(fs/1e6) ' Mhz 实信号相频响应'])

    subplot(133);
    plot3(1:length(A),real(A),imag(A));grid on
    xlabel('点数');ylabel('实部');zlabel('虚部');
    axis([0 length(A) -max(abs(A)) max(abs(A)) -max(abs(A)) max(abs(A))])
    %----------------------------------------------------------------------
    if nargin <=3                                                           %如果不输入 自动寻找最大值
        select = find(A==max(A));
        ang = rad2deg(angle(A(select)));
    end

    if nargin ==4
        ang = rad2deg(angle(A(select)));
    end
    title(['最大值对应 -> 点 ' num2str(select) ' 相位为 ' num2str(ang) ' °']);
    %----------------------------------------------------------------------

end