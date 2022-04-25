%--------------------------------------------------------------------------
%   [dataout] = steeringvector(array_pos,sig_pos)
%--------------------------------------------------------------------------
%   功能:
%   空间传播方法计算导向矢量
%--------------------------------------------------------------------------
%   输入:
%           array_pos               接收信号阵列坐标，按照列排列
%           sig_pos                 发射信号阵列坐标 按照列排列
%           lambda                  载频波长
%   输出:
%           A                       导向矢量
%--------------------------------------------------------------------------
%  例子:
% c = 3e8;
% fc = 20e9;
% lambda = c/fc;
% tgt_angle = [50 90 140];                                                    
% R = [1000 5600 9000];
% 
% tgt_pos = [R.*cosd(tgt_angle);R.*sind(tgt_angle);zeros(1,3)]; 
% radar_pos = [zeros(1,8);lambda/2*(1:8)-4*lambda/2 - lambda/4;zeros(1,8)];
% steering_vector(radar_pos,tgt_pos(:,1),lambda)
%--------------------------------------------------------------------------
function A = steering_vector(array_pos,sig_pos,lambda)
for idx = 1:size(array_pos,2)
    R(idx,:) = norm(array_pos(:,idx)-sig_pos);
end
A = exp(1j.*2*pi*R./lambda);
A = conj(A);
end