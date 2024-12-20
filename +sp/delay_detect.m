%--------------------------------------------------------------------------
%   L = delay_detect(sig,delay_N,th)
%--------------------------------------------------------------------------
%   功能：
%   信号幅度检测算法(用于非协作信号)
%--------------------------------------------------------------------------
%   输入:
%           sig         待检测信号 按照列排列
%           delay_N     延迟点数    延迟不应该大于信号的长度,否则出问题
%           th          最小门限
%   输出:
%           L           判决结果         
%--------------------------------------------------------------------------
%   例子:
%   L = delay_detect(sig,100)
%   L = delay_detect(sig,100,2)
%--------------------------------------------------------------------------
function L = delay_detect(sig,delay_N,th)
if nargin<=2
    th = 0;
end
sig = abs(sig);                                                             %幅度信号
for jdx = 1:size(sig,2)

    %   三路延迟信号
    abs_sig = abs(sig(:,jdx));
    
    delay1 = [zeros(delay_N*1,1);abs_sig;zeros(delay_N*3,1)];
    delay2 = [zeros(delay_N*2,1);abs_sig;zeros(delay_N*2,1)];
    delay3 = [zeros(delay_N*3,1);abs_sig;zeros(delay_N*1,1)];
    
    delta = 1/3;
    th3 = [delay1 delay2 delay3].*delta;
    th2 = max(th3,[],2);
    L1 = (abs_sig > th2(delay_N*2+1:end - delay_N*2)) & (abs_sig > th);
    
    %--------------------------------------------------------------------------
    %   连续出现50个1为检测到信号,去除检测毛刺
    %--------------------------------------------------------------------------
    cnt = 0;
    for idx = 1:length(L1)
        if L1(idx,:) == 1
            cnt = cnt + 1 ;
        else
            cnt = 0;
        end
        if cnt > 50
            L2(idx,:) = 1;
        else
            L2(idx,:) = 0;
        end
    end
    index = findhead(L2,[0 1]);
    %   补上开头丢失的50个1
    for ndx = 1:length(index)
        L2(index(ndx)-49:index(ndx),:) = 1;
    end
    L(:,jdx) = L2(:);
end
end

function index = findhead(data,target)
data = data(:);
target = target(:);
N = length(target);
for idx = 1:N
    L(:,idx) = circshift(data == target(idx),1-idx);
end
L = sum(L,2);
index = find(L == N);
end
