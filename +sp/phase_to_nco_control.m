%--------------------------------------------------------------------------
%   nco_control_words = phase_to_nco_control(phi_diff, N)
%--------------------------------------------------------------------------
%   功能：
%   将相位增量 phi_diff 转换为 NCO 控制字
%--------------------------------------------------------------------------
%   输入：
%           phi_diff            相位增量向量 (弧度)
%   N       NCO                 相位累加器位宽 (例如 32)
% 输出：
%   nco_control_words           控制字向量 (整数)
%--------------------------------------------------------------------------
function nco_control_words = phase_to_nco_control(phi_diff, N)
    % 归一化相位增量到 [0, 2*pi) 范围
    phi_diff_normalized = mod(phi_diff, 2 * pi);
    % 转换为控制字
    nco_control_words = round((phi_diff_normalized / (2 * pi)) * (2^N));
end
