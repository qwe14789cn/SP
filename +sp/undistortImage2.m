%--------------------------------------------------------------------------
%   [undistorted_img,...
%    pixel_trans_u,...
%    pixel_trans_v] = undistortImage2(img, K, D)
%--------------------------------------------------------------------------
%   功能：
%   图像畸变矫正还原(张正友畸变还原算法)
%--------------------------------------------------------------------------
%   输入：
%           img                     待校正图像
%           K                       内参矩阵
%           D                       径向畸变系数k1 k2
%   输出：
%           undistorted_img         校正后图像
%           pixel_trans_u           水平方向
%           pixel_trans_v           垂直方向
%--------------------------------------------------------------------------
%   例子：
%   images = imageDatastore(fullfile(toolboxdir('vision'),'visiondata', ...
%     'calibration','mono'));
%   [imagePoints,boardSize] = detectCheckerboardPoints(images.Files);
%   squareSize = 29;
%   worldPoints = generateCheckerboardPoints(boardSize,squareSize);
%   I = readimage(images,1); 
%   imageSize = [size(I,1),size(I,2)];
%   cameraParams = estimateCameraParameters(imagePoints,worldPoints, ...
%                                   'ImageSize',imageSize);
%
%   [uimxy,u,v] = undistortImage2(I,...
%                                 cameraParams.IntrinsicMatrix.',...
%                                 cameraParams.RadialDistortion);
%--------------------------------------------------------------------------
function [undistorted_img,...
        pixel_trans_u,...
        pixel_trans_v] = undistortImage2(img, K, D)
[height, width,~] = size(img);                                               %获取图片尺寸
fx = K(1,1);                                                                %内参矩阵 x方向比例因子
fy = K(2,2);                                                                %内参矩阵 y方向比例因子
cx = K(1,3);                                                                %x方向像素偏移补偿
cy = K(2,3);                                                                %y方向像素偏移补偿

undistorted_img = eval([class(img) '(zeros(size(img)))']);                             %矫正后缓冲数据
pixel_trans_u = zeros(height,width);
pixel_trans_v = zeros(height,width);
%--------------------------------------------------------------------------
%   图像原始坐标索引点
%--------------------------------------------------------------------------
[X,Y] = meshgrid(1:width,1:height);                                         %X Y 表示水平 垂直方向坐标

%--------------------------------------------------------------------------
%   内参矩阵归一化畸变矫正坐标
%--------------------------------------------------------------------------
X1 = (X-cx)./fx;
Y1 = (Y-cy)./fy;

%--------------------------------------------------------------------------
%   径向畸变模型得到归一化的畸变坐标
%--------------------------------------------------------------------------
R2 = X1.^2+Y1.^2;
X2 = X1.*(1+D(1).*R2+D(2).*R2.^2);
Y2 = Y1.*(1+D(1).*R2+D(2).*R2.^2);

%--------------------------------------------------------------------------
%   重新映射坐标到原始图像
%--------------------------------------------------------------------------
u_distorted = fx.*X2 + cx;                                                  %图像的行坐标
v_distorted = fy.*Y2 + cy;                                                  %图像的列坐标

%--------------------------------------------------------------------------
%   坐标越界处理
%--------------------------------------------------------------------------
%   水平方向
%--------------------------------------------------------------------------
u_distorted(u_distorted<1)=nan;
u_distorted(u_distorted>width)=nan;

%--------------------------------------------------------------------------
%   垂直方向
%--------------------------------------------------------------------------
v_distorted(v_distorted<1)=nan;
v_distorted(v_distorted>height)=nan;

%--------------------------------------------------------------------------
%   重新填充像素
%--------------------------------------------------------------------------
for xdx = 1:width
    for ydx = 1:height
        if isnan(u_distorted(ydx,xdx)) || isnan(v_distorted(ydx,xdx))
            continue
        else
            %   应该采用最邻近插值,这里偷懒直接选择最靠近的像素填充
            undistorted_img(ydx,xdx,:) = img(round(v_distorted(ydx,xdx)),round(u_distorted(ydx,xdx)),:);
            pixel_trans_u(ydx,xdx) = u_distorted(ydx,xdx);
            pixel_trans_v(ydx,xdx) = v_distorted(ydx,xdx);
        end
    end
end
