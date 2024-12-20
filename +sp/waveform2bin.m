%--------------------------------------------------------------------------
%   waveform2bin(sig,filename)
%--------------------------------------------------------------------------
%   功能：
%   生成8267D波形bin文件
%--------------------------------------------------------------------------
%   输入:
%           sig         输入信号
%           filename    保存文件名
%--------------------------------------------------------------------------
%   例子:
%   waveform2bin(sig,'waveform.bin')
%--------------------------------------------------------------------------
function waveform2bin(sig,filename)
temp = [real(sig(:)) imag(sig(:))].';
waveform = temp(:);
waveform = waveform / max(abs(waveform));
waveform = round(waveform * 32767);

f = fopen(filename,'w');
fwrite(f,waveform,'int16','b');
fclose(f);
end