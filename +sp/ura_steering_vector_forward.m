%--------------------------------------------------------------------------
%   [A,index] = ura_steering_vector_forward(lambda,dy,dz,Ny,Nz,fai_degree,theta_degree)
%--------------------------------------------------------------------------
%   功能：
%   二维线阵导向矢量,前视阵坐标系
%--------------------------------------------------------------------------
%   输入:
%           lambda              载波波长
%           dy                  水平方向阵列间距
%           dz                  垂直方向阵列间距
%           Ny                  水平方向阵元总数
%           Nz                  垂直方向阵元总数
%           fai_degree          方位角，单位用度
%           theta_degree        俯仰角，单位用度
%           水平窗
%           垂直窗
%   输出:
%           A                   导向矢量
%           Index               阵列排布序号
%           
%   o----------------------------->  Dy
%   |   1   6   11  16  21  26
%   |   2   7   12  17  22  27
%   |   3   8   13  18  23  28
%   |   4   9   14  19  24  29
%   |   5   10  15  20  25  30
%   ↓
%   Dz
%--------------------------------------------------------------------------
%   例子:
%   [A,index] = ura_steering_vector_forward(lambda,dy,dz,Ny,Nz,fai_degree,theta_degree)
%--------------------------------------------------------------------------
function [A,angle,index] = ura_steering_vector_forward(lambda,dy,dz,Ny,Nz,fai_degree,theta_degree)
index = reshape((1:Ny*Nz),Nz,[]);
DY = 0:(Ny-1);
DZ = 0:(Nz-1);
A_dy = exp(1j.*2*pi./lambda.*dy.*DY.*sind(fai_degree).*cosd(theta_degree)); %水平方向导向矢量
A_dz = exp(1j.*2*pi./lambda.*dz.*DZ.*sind(theta_degree));                   %垂直方向导向矢量
A = A_dy.*A_dz.';

angle_dy = 2*pi./lambda.*dy.*DY.*sind(fai_degree).*cosd(theta_degree);      %水平方向导向矢量
angle_dz = 2*pi./lambda.*dz.*DZ.*sind(theta_degree);                        %垂直方向导向矢量
angle = angle_dy + angle_dz';

end