%--------------------------------------------------------------------------
%   [output,pix_num] = auto_fusion(input_data,conn)
%--------------------------------------------------------------------------
%   功能：
%   寻找在二进制图像中的最大连通域并给出连通域的质心,图像，雷达中比较常用
%   雷达中用于估计目标的参数，将量化的数据小数点化
%--------------------------------------------------------------------------
%   input:
%           inputdata           连通域图像
%           conn                1/4/6/8/18/26联通
%
%   output:
%           output              连通域质心
%                               格式：
%                               |X坐标 | Y坐标|
%                                 x1      y1
%                                 x2      y2
%                                ....    ....
%           pix_num             像素数
%--------------------------------------------------------------------------
%   例子:
%   test = peaks>2;
%   auto_fusion(test,8)
%--------------------------------------------------------------------------
function [output,pix_num] = auto_fusion(input_data,conn)
CC = bwconncomp(input_data,conn);
N = CC.NumObjects;
output = zeros(N,2);
S = regionprops(CC,'Centroid');
for idx = 1:N
    output(idx,:) = S(idx).Centroid;
    pix_num(idx,:) = numel(CC.PixelIdxList{idx});
end
end
