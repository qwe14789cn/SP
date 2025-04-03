%--------------------------------------------------------------------------
%   h = lagrange_fractional_delay(L,x)
%--------------------------------------------------------------------------
%   功能:
%   拉格朗日分数延迟滤波器
%   (注意,适用于实数信号，复数信号需要补偿载波相位)
%--------------------------------------------------------------------------
%   输入：
%           L           FIR滤波器点数(注意滤波器阶数为L-1)
%           x           分数延迟点数
%   输出：  
%           h           拉格朗日延迟滤波器(输入变量为2个)
%                       farrow滤波器(输入变量为1个)
%--------------------------------------------------------------------------
%   例子:
% D = 0.1;                                                                    %延迟小数
% N = 11;                                                                     %滤波器点数
% h_lagr = h_lagrange_farrow(N,D);                                            %拉格朗日延迟
% h_farrow = h_lagrange_farrow(N);                                            %farrow滤波器
% 
% sig = randn(100,1);                                                         %产生信号
% output_lagr = sp.filter_w(sig,h_lagr);                                      %信号延迟
% output_farrow = sp.filter_w(sig,h_farrow);                                  %farrow滤波器卷积
% 
% sig_out_farrow = zeros(size(output_lagr));                                  %farrow输出缓冲区
% 
% for idx = 1:size(h_farrow,2)
%     sig_out_farrow = sig_out_farrow + output_farrow(:,idx);
%     if idx ~= size(h_farrow,2)                                              %最后一级跳过
%         sig_out_farrow = sig_out_farrow*D;                                  %叠加延迟点数
%     end
% end
% 
% %   可视化
% plot(circshift(sig,5),'d-');hold on
% plot(output_lagr,'o-')
% plot(sig_out_farrow,'x-');hold off;grid on
%--------------------------------------------------------------------------
function h = lagrange_fractional_delay(L,x)
N = L-1;                                                                    % 滤波器阶数
M = N/2;                                                                    % 中心值

if (M-round(M))==0 
    D= x + M;                                                               % 整数部分居中
else
    D= x + M - 0.5;
end
%--------------------------------------------------------------------------
%   构造矩阵 K N
%   矩阵运算各个矩阵元素(D-K)./(N-K) 拉格朗日公式
%   对角线元素替换为1
%   叠乘拍扁
%--------------------------------------------------------------------------
K_matrix = repmat((0:L-1),L,1);     
N_matrix =repmat((0:L-1)',1,L);
for idx = 1:numel(D)
    lagr_matrix = (D(idx)-K_matrix)./(N_matrix-K_matrix);
    lagr_matrix(logical(eye(L))) = 1;
    h(:,idx) = prod(lagr_matrix,2);
end



