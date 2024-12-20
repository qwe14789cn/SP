%--------------------------------------------------------------------------
%   far_field_conditions(D,lambda)
%--------------------------------------------------------------------------
%   功能：
%   雷达相控阵系统远场假设
%--------------------------------------------------------------------------
%   输入:
%           D           天线孔径
%           lambda      波长
%   输出:
%           R           最小距离 
%--------------------------------------------------------------------------
%   例子:
%   far_field_conditions(3,0.01)
%--------------------------------------------------------------------------
function R = far_field_conditions(D,lambda)
R = 2*(D^2)/lambda;
disp(['远场距离至少 ' num2str(R,'%2.5f') ' m'])
end
