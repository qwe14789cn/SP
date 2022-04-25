%--------------------------------------------------------------------------
%   show_vector(points)
%--------------------------------------------------------------------------
%   功能：
%   二维与三维列向量可视化
%--------------------------------------------------------------------------
%   输入：
%           points                  二维或者三维列向量可视化，发射光源为原点
%--------------------------------------------------------------------------
%	例子:
%	show_vector(randn(3,8))
%   show_vector(randn(2,8))
%--------------------------------------------------------------------------
function show_vector(points)
if size(points,1) == 3
    for idx = 1:size(points,2)
        quiver3(0,0,0,points(1,idx),points(2,idx),points(3,idx));
        text(points(1,idx),points(2,idx),points(3,idx),num2str(idx))
        hold on
    end
    
hold off
elseif size(points,1) == 2
    for idx = 1:size(points,2)
        quiver(0,0,points(1,idx),points(2,idx));
        text(points(1,idx),points(2,idx),num2str(idx))
        hold on
    end
	hold off
end