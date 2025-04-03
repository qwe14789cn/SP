%--------------------------------------------------------------------------
%   [sig,fs] = read_std(file_name)
%--------------------------------------------------------------------------
%   功能:
%   读取*.std数据波形
%--------------------------------------------------------------------------
%   输入:
%           file_name                  文件名
%   输出:
%           sig                        输出波形
%           fs                         采样率
%           info                       文件信息
%--------------------------------------------------------------------------
function [sig,fs,info] = read_std(filename)
%   读取信息
data = read_bin(filename,'uint8','l',50);

switch data(10)
    case 0
        type = "int8";
    case 1
        type = "int16";
    case 2
        type = "int32";
end

%值1 表示实通道AD 数据，值2表示复通道IQ 数据
switch typecast(uint8(data(11:12)),'int16')
    case 1
        IQ = "实信号";
    case 2
        IQ = "复信号";
end

% 用1 个双字节整数（short）整数表示，值0 表示信号的频谱为正向，值1 表示信号
    % 的频谱为反转后的频谱。
switch typecast(uint8(data(13:14)),'int16')
    case 0
        freq = "频谱正向";
    case 1
        freq = "频谱反向";
end


info = table(str2double(strjoin(cellfun(@num2str, num2cell(data(1:2)), 'UniformOutput', false), '')),...
                     data(3),data(4),data(5),data(6),data(7),...
                     str2double(strjoin(cellfun(@num2str, num2cell(data(8:9)), 'UniformOutput', false), '')),...
                     type,IQ,freq,typecast(int8(data(15:16)),'int16'),...
                     typecast(uint8(data(17:18)),'int16'),...
                     typecast(uint8(data(19:26)),'double'),...
                     typecast(uint8(data(27:34)),'double'),...
                     typecast(uint8(data(35:42)),'double'),...
                     typecast(uint8(data(43:50)),'double'),...
      'VariableNames',{'年','月','日','时','分','秒','毫秒',...
                       '数据格式','数据类型','频谱方向','数据通道采集数',...
                       '数据采集的通道号','射频调谐器调谐中心频率(Hz)',...
                       '中频调谐器调谐中心频率(Hz)','中频信道带宽(Hz)',...
                       '采样频率(Hz)'});


data2 = read_bin(filename,'int8','l');
if type == "int8"
    data2 = data2(51:end);
elseif type == "int16"
    data2 = typecast(int8(data2(51:end)),'int16');
elseif type == "int32"
    data2 = typecast(int8(data2(51:end)),'int32');
end
data2 = double(data2);

if typecast(uint8(data(11:12)),'int16') == 1
    %   实信号
    sig = data2;
elseif typecast(uint8(data(11:12)),'int16') == 2 
    %   复信号
    %   奇数/偶数处理
    if rem(length(data2),2) == 1
        data2 = data2(1:end-1);
    end
    sig = data2(1:2:end) + 1j.*data2(2:2:end);
end

fs = typecast(uint8(data(43:50)),'double');

disp(rows2vars(info))








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