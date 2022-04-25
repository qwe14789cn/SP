%--------------------------------------------------------------------------
%   [result,t,u,v] = picking(O,D,tringle)
%--------------------------------------------------------------------------
%   功能：
%   判断射线与三角形面是否有交点
%   射线和三角形的相交检测（ray triangle intersection test）
%   https://www.cnblogs.com/graphics/archive/2010/08/09/1795348.html
%--------------------------------------------------------------------------
%   输入：
%           O                   发射光源坐标
%           D                   射线矢量方向   O→D形成出光矢量
%           tringle             三角形三个点形成的曲面，按照列向量排列点
%   输出：
%           result              1为有交点，0为无交点
%           t                   矢量长度t
%           u                   纹理值u
%           v                   纹理值v
%   交点坐标为计算公式为 
%   O + Dt
%   (1-u-v)*V0+u*V1+v*V2
%--------------------------------------------------------------------------
%   例子：
%   w = [1 -1 1;0 1 1;-1 -1 1]';
%   [result,t,u,v] = picking([0 0 0]',[10 0 1]',w)
%   [result,t,u,v] = picking([0 0 0]',[10 10 1]',w)
%--------------------------------------------------------------------------
function [result,t,u,v] = picking(O,D,tringle)
V0 = tringle(:,1);V1 = tringle(:,2);V2 = tringle(:,3);
E1 = V1 - V0;E2 = V2 - V0;P = cross(D,E2);
DET = dot(E1,P);
if DET>0
    T = O - V0;
else
    T = V0 - O;
    DET = - DET;
end
if DET < 0.0001
    result = false;
    [t,u,v] = deal([]);
    return
end

u = dot(T,P);
if u <0.0 || u > DET
    result = false;
    [t,u,v] = deal([]);
    return
end

Q = cross(T,E1);
v = dot(D,Q);

if v < 0.0 || (u + v) > DET
    result = false;
end

t = dot(E2,Q);
finvdet = 1/DET;
t = t*finvdet;
u = u*finvdet;
v = v*finvdet;
result = true;
