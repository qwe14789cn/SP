%--------------------------------------------------------------------------
%   [dataout] = read_bin(file_name,file_type,mode_bl,N)
%--------------------------------------------------------------------------
%   功能:
%   读取bin文件数据
%--------------------------------------------------------------------------
%   输入:
%           file_name                  文件名
%           file_type                  类型,如int8,single(float),double
%           mode_bl                    大小端     'n'系统默认
%                                                 'b' 大端(常用)
%                                                 'l' 小端(常用)
%                                                 's' 大端64bit
%                                                 'a' 小端64bit
%           N                           读取长度
%   输出:
%           output                     输出读取数据结果
%--------------------------------------------------------------------------
%   例子:   
%   read_bin('1.bin','int8')
%   read_bin('1.bin','int8','b')
%   read_bin('1.bin','int8','b',2)
%   read_bin('1.bin','int8',[],2)
%--------------------------------------------------------------------------
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