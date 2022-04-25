%--------------------------------------------------------------------------
%   write_bin(data_name,file_name,file_type,mode_bl)
%--------------------------------------------------------------------------
%   功能：
%   写入bin文件数据
%--------------------------------------------------------------------------
%   输入：
%           data_name               输入数据变量名
%           file_name               写入数据文件名
%           file_type               类型,如int8,single(float),double
%           mode_bl                    大小端     'n'系统默认
%                                                 'b' 大端(常用)
%                                                 'l' 小端(常用)
%                                                 's' 大端64bit
%                                                 'a' 小端64bit
%--------------------------------------------------------------------------
%   例子:
%   a = [1 2 3;4 5 6;7 8 9];
%   write_bin(a,'a.bin')
%   write_bin(a,'a.bin','l')
%--------------------------------------------------------------------------
function write_bin(data_name,file_name,file_type,mode_bl)
if nargin == 3
    mode_bl = 'n';
end
f = fopen(file_name,'w');
fwrite(f,data_name,file_type,mode_bl);
fclose(f);
end