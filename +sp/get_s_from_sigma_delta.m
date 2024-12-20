%--------------------------------------------------------------------------
%   [fai,E_Sigma,E_Delta] = get_s_from_sigma_delta(angle_axis,Sigma_weight,Delta_weight)
%--------------------------------------------------------------------------
%   功能：
%   和差波束方向图绘制查找S曲线
%--------------------------------------------------------------------------
%   输入:
%           angle_axis          角度范围
%           Sigma_weight        和波束权系数
%           Delta_weight        差波束权系数  
%   输出:
%           fai                 测角查找表
%           E_Sigma             和波束
%           E_Delta             差波束
%--------------------------------------------------------------------------
%   例子:
%   angle_axis = -90:0.01:90;
%   fai = get_s_from_sigma_delta(angle_axis,Sigma_weight,Delta_weight)
%   plot(angle_axis,fai)
%--------------------------------------------------------------------------
function [fai,E_Sigma,E_Delta] = get_s_from_sigma_delta(angle_axis,Sigma_weight,Delta_weight)
angle_axis = angle_axis(:)';
N1 = numel(Sigma_weight);N2 = numel(Delta_weight);
if N1 == N2
    N = N1;
else
    disp('和差波束加权阵元数不一样')
    return
end

lambda = 1;
dd = 0.5;
d = 0:dd:(N-1)*dd;
idx = 1;

for theta_step = angle_axis
    A = exp(1j.*2*pi*d.'*sind(theta_step)/lambda);
    E_Sigma(idx,:) = Sigma_weight(:)'*A;
    E_Delta(idx,:) = Delta_weight(:)'*A;
    idx = idx + 1;
end
% fai = abs(E_Delta)./abs(E_Sigma).*sign(angle(conj(E_Sigma).*E_Delta));      %这两个写法一样
fai = imag(E_Delta./E_Sigma);                                               %写法一样
if nargout == 0
    plot(angle_axis,fai);grid on
end

fai = fai(:);