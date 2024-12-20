%--------------------------------------------------------------------------
%   function [theta_dy,theta_dz] = polar2cartesian_coordinate(theta,fai)
%--------------------------------------------------------------------------
%   功能：
%   转台极坐标转直角坐标系
%--------------------------------------------------------------------------
%   输入:
%           theta           偏心角
%           fai             旋转角
%--------------------------------------------------------------------------
%   输出:
%           theta_dy        y轴夹角(直角坐标系下)        
%           theta_dz        z轴夹角(直角坐标系下)
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
function [theta_d_dy,theta_d_dz] = polar2cartesian_coordinate(theta_d,fai_d)
Vector = [1 0 0]';
V = rotate_xd(fai_d)*rotate_zd(theta_d)*Vector;

theta_d_dy = atand(V(2)/V(1));
theta_d_dz = atand(V(3)/sqrt(V(2).^2+V(1).^2));

end

function yaw = rotate_xd(thetad)
yaw = [1 0 0;0 cosd(thetad) -sind(thetad);0 sind(thetad) cosd(thetad)];
end

function yaw = rotate_zd(thetad)
yaw = [cosd(thetad) -sind(thetad) 0;sind(thetad) cosd(thetad) 0;0 0 1];
end



