%--------------------------------------------------------------------------
%   [peak_angle,SPA_capon_dB,angle_list] = capon_doa_est(sig)
%--------------------------------------------------------------------------
%   功能：
%   一维线阵超分辨Capon测角算法
%--------------------------------------------------------------------------
%   输入:
%           sig                     阵列信号
%           N_peaks                 选取多少个峰值
%   输出:
%           peak_angle              测量角度
%           SPA_capon_dB            capon超分辨估计功率谱(dB)
%           angle_list              角度轴
%--------------------------------------------------------------------------
%   例子:
%   array_doa_est(sig)                %一维线阵直接出图
%   array_doa_est(sig,3)              %一维线阵直接出图
%   peak_angle = array_doa_est(sig) %信号来向角
%--------------------------------------------------------------------------
function [peak_angle,SPA_capon_dB,angle_list] = capon_doa_est(sig,N_peaks)
N = size(sig,2);
dd = (0:N-1)';
angle_list = -90:0.01:90;
A = exp(1j.*pi.*dd.*sind(angle_list));                                      %构建导向矢量
Rxx=sig'*sig;                                                               % 得到信号的协方差矩阵
Rxx_inv = Rxx^-1;
SP_capon = zeros(size(angle_list));
%--------------------------------------------------------------------------
%   循环搜索
%--------------------------------------------------------------------------
for idx = 1:length(angle_list)
    a = A(:,idx);
    SP_capon(idx) = 1 ./ (a'*Rxx_inv*a);
end
%   绘制功率谱
SP_capon_abs=abs(SP_capon);
SPA_capon_dB=mag2db(SP_capon_abs/max(SP_capon_abs(:)));

%   搜索最大值
if nargin <= 1 
    [~,adx] = findpeaks(SPA_capon_dB,"MinPeakHeight",-30);
    peak_angle = angle_list(adx);
else
    [~,adx] = findpeaks(SPA_capon_dB,"NPeaks",N_peaks,'SortStr','descend');
    peak_angle = angle_list(adx);
end

%   如果没有输出，则可视化
if nargout <= 0 
    plot(angle_list,SPA_capon_dB,'LineWidth',2);grid on
    hold on
    plot(angle_list(adx),SPA_capon_dB(adx),'ro','MarkerSize',10)
    hold off
    title(num2str(peak_angle))
	xlabel('角度/°');ylabel('功率谱/dB')
end
