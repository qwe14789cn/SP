%--------------------------------------------------------------------------
%   out = sig_delay(sig,R,lambda,fs,type)
%--------------------------------------------------------------------------
%   功能：
%   信号延迟函数,支持 整数时延(Integer Delay) 和 分数时延(Fractional Delay)
%   并添加复信号的相位旋转
%   整数时延采用四舍五入法对信号进行整数延迟
%   分数时延采用分数时延滤波器进行信号延迟
%--------------------------------------------------------------------------
%   输入:
%           sig         发射复信号
%           R           传输距离
%           lambda      载频波长
%           fs          仿真采样速率
%           type        延迟类型,默认为id,可以设置id,fd
%   输出:
%           out         延迟信号
%--------------------------------------------------------------------------
%   例子:
%   out = sig_delay(sig,R,lambda,fs,'id')
%   out = sig_delay(sig,R,lambda,fs,'fd')
%--------------------------------------------------------------------------
function out = sig_delay(sig,R,lambda,fs,type)
if nargin <= 4
    type = 'id';                                                            %整数时延
end
type = lower(type);

sig = sig(:);                                                               %信号按照列向量排
R = R(:)';                                                                  %延迟按照行向量排
sig_len = numel(sig);
%   计算时间延迟
c = 3e8;
delay_time = R/c;                                                           %计算延迟时间
T = 1/fs;                                                                   %采样间隔

%   计算相位延迟
phi = exp(-1j.*R/lambda*2*pi);                                               %传播过程中载频产生的相位旋转

switch type
    case 'id'
        delay_N = round(delay_time/T);                                      %信号延迟计算整数点
        if range(delay_N) == 1
            disp('→存在跨距离单元')
        end
        % disp(['整数时延' num2str(delay_N)])
        max_delay_N =  max(delay_N);                                        %对延迟的距离统一
        out = zeros(numel(sig)+max_delay_N,numel(R));                       %信号延迟缓冲区
        for idx = 1:numel(delay_N)
            out(delay_N(idx)+1:delay_N(idx)+sig_len,idx) = sig;
        end
        %   添加相位
        out = out.*phi;                                                             %相位添加到每次回波上
    case 'fd'
        % disp(['分数时延:' num2str(delay_time/T) ' sig band <= 0.9*fs'])
        %   整数部分
        delay_N = floor(delay_time/T);
        if range(delay_N) == 1
            disp('→存在跨距离单元')
        end
        %   小数部分
        % mod(delay_time,T);
        max_delay_N =  max(delay_N);
        out = zeros(numel(sig)+max_delay_N,numel(R));    

        h = h_lagrange_farrow(501,mod(delay_time,T));
        output_sig = filter_w(sig,h);
        output_sig = output_sig.*phi;
        output_sig = output_sig(251:end-250,:);
        %   延迟信号
        for idx = 1:numel(delay_N)
            out(delay_N(idx)+1:delay_N(idx)+sig_len,idx) = output_sig(:,idx);
        end

end



end

function h = h_lagrange_farrow(L,x)
N = L-1;
M = N/2;
if (M-round(M))==0 
    D= x + M;
else
    D= x + M - 0.5;
end
K_matrix = repmat((0:L-1),L,1);     
N_matrix =repmat((0:L-1)',1,L);
for idx = 1:numel(D)
    lagr_matrix = (D(idx)-K_matrix)./(N_matrix-K_matrix);
    lagr_matrix(logical(eye(L))) = 1;
    h(:,idx) = prod(lagr_matrix,2);
end
end

function output = filter_w(sig,w)
if size(w,2) == 1 && size(sig,2)>=1

    for idx = 1:size(sig,2)
        output(:,idx) = conv(sig(:,idx),w);
    end
elseif size(w,2) == size(sig,2)
    for idx = 1:size(sig,2)
        output(:,idx) = conv(sig(:,idx),w(:,idx));
    end
elseif size(sig,2) == 1&& size(w,2)>1
    for idx = 1:size(w,2)
        output(:,idx) = conv(sig,w(:,idx));
    end
else
    disp('向量长度不匹配')
    output = [];
end
end
