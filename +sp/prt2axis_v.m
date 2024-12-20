%--------------------------------------------------------------------------
%   v_axis = prt2axis_v(prt,lambda,N)
%--------------------------------------------------------------------------
%   功能:
%   根据雷达发射的PRT时间和载波频率及N点fft点数计算多普勒速度轴
%--------------------------------------------------------------------------
%   输入:
%           prt             脉冲间隔时间 s
%           lambda          发射波长
%           N               做fft的点数
%   输出:
%           v_axis          速度轴 m/s
%--------------------------------------------------------------------------
function v_axis = prt2axis_v(prt,lambda,N)
PRF = 1/prt;vmax = PRF*lambda/2;
if rem(N,2) == 0
    v_axis = fftshift((0:N-1)*vmax./N - vmax/2);
else
    v_axis = (0:N-1)*vmax./N - vmax/N*(N-1)/2;
    v_axis = [v_axis(((N+1)/2):end) v_axis(1:(N-1)/2)];
end
v_axis = v_axis(:);
end