%--------------------------------------------------------------------------
%   complex2vector(points,model)
%--------------------------------------------------------------------------
%   功能：
%   复数矢量可视化工具
%--------------------------------------------------------------------------
%   输入：
%           points          复数，按照行放置
%           model           不输入 或者输入 '3d' 选择绘制模式
%--------------------------------------------------------------------------
%	例子:
%   complex2vector(randn(1,5) + 1j.*randn(1,5))                          %二维画图
%	complex2vector(randn(1,5) + 1j.*randn(1,5),'3d')                     %三维画图
%--------------------------------------------------------------------------
function complex2vector(points,model)
if nargin == 1
    for idx = 1:numel(points)
        quiver(0,0,real(points(idx)),imag(points(idx)));
        text(real(points(idx)),imag(points(idx)),num2str(idx));
        hold on
    end
elseif model == '3d'
    for idx = 1:numel(points)
        quiver3(idx,0,0,   0,real(points(idx)),imag(points(idx)));
        text(idx,real(points(idx)),imag(points(idx)),num2str(idx));
        hold on
    end
    plot3(1:numel(points),zeros(1,numel(points)),zeros(1,numel(points)),'k','LineWidth',1)
    plot3(1:numel(points),zeros(1,numel(points)),zeros(1,numel(points)),'ro','LineWidth',1)

end
hold off;grid on;
