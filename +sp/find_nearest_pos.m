%--------------------------------------------------------------------------
%   pos = find_nearest_pos(LUT,data)
%--------------------------------------------------------------------------
%   功能：
%   寻找查找表中最接近查找值的位置
%--------------------------------------------------------------------------
%   输入:
%           LUT             查找表
%           data            查找值
%   输出:
%           pos             最接近查找值的位置
%--------------------------------------------------------------------------
function pos = find_nearest_pos(LUT,data)
[~,pos] = min(abs(LUT-data));
end