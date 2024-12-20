%--------------------------------------------------------------------------
%   complex2vector(points,model)
%--------------------------------------------------------------------------
%   ���ܣ�
%   ����ʸ�����ӻ�����
%--------------------------------------------------------------------------
%   ���룺
%           points          �����������з���
%           model           ������ �������� '3d' ѡ�����ģʽ
%--------------------------------------------------------------------------
%	����:
%   complex2vector(randn(1,5) + 1j.*randn(1,5))                          %��ά��ͼ
%	complex2vector(randn(1,5) + 1j.*randn(1,5),'3d')                     %��ά��ͼ
%--------------------------------------------------------------------------
function complex2vector(points,model)
if nargin == 1
    model = '2D';
end
if upper(model) == "2D"
    for idx = 1:numel(points)
        quiver(0,0,real(points(idx)),imag(points(idx)));
        text(real(points(idx)),imag(points(idx)),num2str(idx));
        hold on
    end
elseif upper(model) == "3D"
    for idx = 1:numel(points)
        quiver3(idx,0,0,   0,real(points(idx)),imag(points(idx)));
        text(idx,real(points(idx)),imag(points(idx)),num2str(idx));
        hold on
    end
    plot3(1:numel(points),zeros(1,numel(points)),zeros(1,numel(points)),'k','LineWidth',1)
    plot3(1:numel(points),zeros(1,numel(points)),zeros(1,numel(points)),'ro','LineWidth',1)
end

hold off;grid on;
