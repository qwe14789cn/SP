%--------------------------------------------------------------------------
%   [vpp] = w2dbm(w)
%--------------------------------------------------------------------------
%   功能:
%   瓦特W转化为分贝毫瓦dbm 
%--------------------------------------------------------------------------
%   输入:
%           w                 
%   输出:
%           dbm
%--------------------------------------------------------------------------
function dbm = w2dbm(w)
dbm = pow2db(w*1e3);
end