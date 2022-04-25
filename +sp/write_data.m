%--------------------------------------------------------------------------
%   write_data(data_name,file_name,data_type)
%--------------------------------------------------------------------------
%   功能:
%   写入matrix 数据 到 *.txt 或者 *.dat 格式.(常用于FPGA数据导入)
%--------------------------------------------------------------------------
%   输入:
%           data_name               数据名称 in workplace
%           file_name               数据保存txt名称
%           data_type               数据保存格式
%--------------------------------------------------------------------------
%   例子:
%   a = [1 2 3;4 5 6;7 8 9];
%   write_data(a,'a.txt','%d ')
%--------------------------------------------------------------------------
function write_data(data_name,file_name,data_type)
f = fopen(file_name,'w');
for idx = 1:size(data_name,1)
    fprintf(f,data_type,data_name(idx,:));
    fprintf(f,'\n');
end
fclose(f);
end
