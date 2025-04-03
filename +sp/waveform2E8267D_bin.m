%--------------------------------------------------------------------------
%   waveform2E8267D_bin(sig,filename)
%--------------------------------------------------------------------------
%   功能：
%   生成8267D波形bin文件
%--------------------------------------------------------------------------
%   输入:
%           sig         输入信号
%           filename    保存文件名
%--------------------------------------------------------------------------
%   例子:
%   waveform2E8267D_bin(sig,'waveform.bin')
%--------------------------------------------------------------------------
function waveform2E8267D_bin(sig,filename)
max_L = max(abs(sig));

if max_L <= 10 || max_L>=32767
    disp('信号能量过小 或 过大，归一化并缩放到±32767')
    sig = round(sig./max_L.*32767);
else
    disp('信号能量满足要求，直接输出不进行归一化')
    sig = round(sig);
end

temp = [real(sig(:)) imag(sig(:))].';
waveform = temp(:);
waveform = waveform / max(abs(waveform));
waveform = round(waveform * 32767);

f = fopen(filename,'w');
fwrite(f,waveform,'int16','b');
fclose(f);
end