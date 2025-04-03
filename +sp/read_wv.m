%--------------------------------------------------------------------------
%   [sig,fs,info] = read_wv(file_name)
%--------------------------------------------------------------------------
%   功能:
%   读取RS *.wv文件数据
%--------------------------------------------------------------------------
%   输入:
%           file_name                  文件名
%   输出:
%           sig                        输出波形
%           fs                         采样率
%           info                       文件信息
%--------------------------------------------------------------------------
function [sig,fs,info] = read_wv(filename)
str = read_bin(filename,'uint8','l');
index = findhead(str,35);                                                   %找到第一个#
index = index(1);
sig = str(index+1:end-1);                                                   %去掉尾巴的}
sig = double(typecast(uint8(sig),'int16'));
sig = sig(1:2:end) + 1j.*sig(2:2:end);


info = char(str(1:index))';
info = split(info,'}{');
info{1} = info{1}(2:end);

info1 = split(info{1},{':',','});
info2 = split(info{2},':');
info3 = split(info{3},':');
info4 = split(info{4},':');
info5 = split(info{5},':');
info6 = split(info{6},':');
info7 = split(info{7},':');

info = table(string(info1{2}),...
      string(info2{2}),...
      string(info3{2}),...
      string(info4{2}),...
      string(info5{2}),...
      string(info6{2}),...
      string(info7{2}),...
      'VariableNames',{info1{1},info2{1},info3{1},info4{1},info5{1},info6{1},info7{1}});

fs =  str2double(table2array(info(1,6)));
disp(rows2vars(info));










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


function index = findhead(data,target)
data = data(:);
target = target(:);
N = length(target);
for idx = 1:N
    L(:,idx) = circshift(data == target(idx),1-idx);
end
L = sum(L,2);
index = find(L == N);
end



end