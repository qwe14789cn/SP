%--------------------------------------------------------------------------
%   sig = read_CSG_AWG_bin(file_name)
%--------------------------------------------------------------------------
%   功能:
%   读取csg/awg的bin文件数据
%--------------------------------------------------------------------------
%   输入:
%           file_name                  文件名
%   输出:
%           sig                        输出波形
%--------------------------------------------------------------------------
function sig = read_CSG_AWG_bin(filename)
data = read_bin(filename,'int16','l');
sig = data(1:2:end) + 1j.*data(2:2:end);

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