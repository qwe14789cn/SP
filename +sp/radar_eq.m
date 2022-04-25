%--------------------------------------------------------------------------
%   [snr] = radar_eq(pt,fc,G,rcs,bw,nf,L,range)
%--------------------------------------------------------------------------
%   功能：
%   雷达方程
%--------------------------------------------------------------------------
%   输入:
%           pt              峰值功率        W
%           fc              中心频率        Hz
%           G               天线增益        dB
%           rcs             雷达反射截面积  m^2
%           bw              信号带宽        Hz
%           nf              噪声系数        dB
%           L               雷达损耗        dB
%           range           目标距离        m
%   输出：
%           snr             信噪比          dB
%--------------------------------------------------------------------------
%   例子：
%   峰值功率1.5MW   中心频率5.6GHz  天线增益45dB    雷达损耗6dB
%   噪声系数3dB     雷达带宽5MHz    最小探测距离25km  最大探测距离165km
%   radar_eq(1.5e6,5.6e9,45,0.1,5e6,3,6,25e3)
%--------------------------------------------------------------------------
function [snr] = radar_eq(pt,fc,G,rcs,bw,nf,L,range)
c      = 3e8;
pt_db  = pow2db(pt);
lambda = c/fc;
lambda_sqdb = pow2db(lambda.^2);
rcs_db      = pow2db(rcs);
four_pi_db  = pow2db((4*pi).^3);

k_db      = pow2db(1.38e-23);
T_db      = pow2db(290);
bw_db     = pow2db(bw);
range_db  = pow2db(range.^4);
A      = pt_db + G + G +lambda_sqdb + rcs_db;
B      = four_pi_db + k_db + T_db + bw_db + nf + L + range_db;
snr =  A-B;
