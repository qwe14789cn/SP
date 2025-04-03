%--------------------------------------------------------------------------
%   [sig,fs,info] = read_seg(file_name)
%--------------------------------------------------------------------------
%   功能:
%   读取Ceyear思仪设备数据格式
%--------------------------------------------------------------------------
%   输入:
%           file_name                  文件名
%   输出:
%           sig                        输出波形
%           fs                         采样率
%           info                       文件信息
%--------------------------------------------------------------------------
function [sig,fs,info] = read_seg(filename)
seg_int16 = read_bin(filename,'int16','l');
seg_int64 = read_bin(filename,'int64','l',12);
fs = seg_int64(2);
info = table(seg_int64(1),seg_int64(2),seg_int64(3),...
      seg_int64(4),seg_int64(5),seg_int64(6),...
      seg_int64(7),seg_int64(8),seg_int64(9),...
      seg_int64(10),seg_int64(11),seg_int64(12),...
      'VariableNames',{'厂家标识','采样率','码元长度',...
                       '过采样点数','样点个数','周期(数据时间 ns)',...
                       '无','文件版本号','IQ偏移量',...
                       'IQ数据峰值','IQ数据均值','12-32保留'});
disp(rows2vars(info));
sig = seg_int16(8193:end);
sig = sig(1:2:end) + 1j.*sig(2:2:end);













function [output] = read_bin(file_name,file_type,mode_bl,N)
if nargin <= 2
    mode_bl = 'n';
end
if isempty(mode_bl)
    mode_bl = 'n';
end
if nargin <= 3                                                              %数据全读取
    f = fopen(file_name,'r');
    output = fread(f,file_type,mode_bl);
    fclose(f);
else                                                                        %数据指定长度
    f = fopen(file_name,'r');
    output = fread(f,N,file_type,mode_bl);
    fclose(f);
end
end
end