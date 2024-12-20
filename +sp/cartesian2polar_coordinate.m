%--------------------------------------------------------------------------
%   function [theta_d,fai_d] = cartesian2polar_coordinate(theta_dy,theta_dz)
%--------------------------------------------------------------------------
%   功能：
%   转台直角坐标系转极坐标系
%--------------------------------------------------------------------------
%   输入:
%           theta_dy        y轴夹角(直角坐标系下)        
%           theta_dz        z轴夹角(直角坐标系下)
%--------------------------------------------------------------------------
%   输出:
%           theta_d         y偏心角(极坐标系下)        
%           fai_d           z旋转角(极坐标系下)
%--------------------------------------------------------------------------
%   从后项看导引头确定坐标系
%--------------------------------------------------------------------------
%   极坐标:
%   偏心30°,旋转75°
%                               90°
%
%                               ^ 
%                               |
%                               |     o (theta,fai)
%                               |    /
%                               |   /
%                               |  /
%                               | /
%                               |/
% 180°  ------------------------X------------------------------>  0°
%                               |
%                               |
%                               |
%                               |
%                               |
%                               |
%                               |
%                               |
%                               -90°
%--------------------------------------------------------------------------
%   例子:   
%   [x,y] = polar2cartesian_coordinate(30,75)
%   x =
%       8.4988
%   y =
%       28.8791
%--------------------------------------------------------------------------
function [theta_d,fai_d] = cartesian2polar_coordinate(theta_dy,theta_dz)
Vector = [1 0 0]';

V = rotate_zd(theta_dy)*rotate_yd(theta_dz)*Vector;

theta_d = atand(sqrt(V(2).^2+V(3).^2)/V(1));
fai_d = -atand(V(3)/V(2));

if theta_dy<0 && theta_dz>0
    fai_d = fai_d+180;
end
if theta_dy<0 && theta_dz<0
    fai_d = fai_d-180;
end


end

function yaw = rotate_yd(thetad)
yaw = [cosd(thetad) 0 sind(thetad);0 1 0;-sind(thetad) 0 cosd(thetad)];
end

function yaw = rotate_zd(thetad)
yaw = [cosd(thetad) -sind(thetad) 0;sind(thetad) cosd(thetad) 0;0 0 1];
end



