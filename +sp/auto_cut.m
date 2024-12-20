%--------------------------------------------------------------------------
% [out,rmsEVM,maxEVM,pctEVM,numSym] = auto_cut(signal,mode,cut_N)
%--------------------------------------------------------------------------
%   功能：
%   FPGA数据截位方法仿真
%--------------------------------------------------------------------------
% mode:1-4(default:4)
%--------------------------------------------------------------------------
% [√] 1.Truncation 舍弃低位，floor(x)
% [√] 2.Non-symmetric Rounding to Positive 加0.5舍弃低位 floor(x+0.5)
% [√] 3.Non-symmetric Rounding to Negative 减0.5舍弃低位 ceil(x-0.5)
% [√] 4.Symmetric Rounding to Highest Magnitude 四舍五入，round(x)
% [×] 5.Symmetric Rounding to Zero 不溢出截位，正数floor，负数ceil(不支持)
% [×] 6.Convergent Rounding to odd(不支持)
% [×] 7.Convergent Rounding to even(不支持)
%--------------------------------------------------------------------------
%   输入:
%           data        输入数据 fi类型定点数据
%           mode        截位方式(默认4)
%           cut_N       截位长度
%--------------------------------------------------------------------------
%   输出:
%           out         输出截位后
%           rmsEVM      均方根误差，统计特性 单位 %
%           maxEVM      最差的一个点特性     单位 %
%           pctEVM      低于95%情况下的 统计特性 单位 %
%           numSym      怂管，没啥用目前
%--------------------------------------------------------------------------
%   例子:
%   auto_cut(signal1)                   %默认模式4四舍五入截位(画图)
%   auto_cut(signal1,1)                 %模式1向下取整截位(画图)
%   auto_cut(signal1,1,14)             %模式1 截位14(画图)
%   out = auto_cut(signal1,1,14)       %模式1 截位14(不画图)
%--------------------------------------------------------------------------
function [out,rmsEVM,maxEVM,pctEVM,numSym] = auto_cut(signal,mode,cut_N)
%--------------------------------------------------------------------------
%   获取变量类型
%--------------------------------------------------------------------------
var = whos('signal');
if ~strcmp(var.class,'embedded.fi')
    disp('变量类型不是 fi 类型')
    return 
end

%--------------------------------------------------------------------------
%   定义截位函数模式
%--------------------------------------------------------------------------
if nargin == 1
    mode = 4;
end
disp('---------------------------------------------------------')
disp('截位模式:')
if mode == 1
    disp('1.Truncation 舍弃低位，floor(x)')
    cut_function = @(x,cut_N)floor(x./(2^cut_N));
elseif mode == 2
    disp('2.Non-symmetric Rounding to Positive 加0.5舍弃低位 floor(x+0.5)')
    cut_function = @(x,cut_N)floor(x./2^cut_N + 0.5);
elseif mode == 3
    disp('3.Non-symmetric Rounding to Negative 减0.5舍弃低位 ceil(x-0.5)')
    cut_function = @(x,cut_N)ceil(x./2^cut_N - 0.5);
elseif mode == 4
    disp('4.Symmetric Rounding to Highest Magnitude 四舍五入，round(x)')
    cut_function = @(x,cut_N)round(x./2^cut_N);
end
disp('---------------------------------------------------------')
%--------------------------------------------------------------------------
%   评估指标
%--------------------------------------------------------------------------
evm = comm.EVM('MaximumEVMOutputPort',true,...
               'XPercentileEVMOutputPort',true,...
               'XPercentileValue',95,...
               'SymbolCountOutputPort',true);
%--------------------------------------------------------------------------
if nargin <= 2
    disp(['自动截位模式 截位方式:' num2str(mode)])
    %----------------------------------------------------------------------
    cut_N = 0;
    while(1)
        signal_raw = double(signal(:));                                     %装入数据
        signal_new = cut_function(signal_raw,cut_N);                        %截位后
        signal_raw = signal_raw./max(abs(signal_raw));                      %归一化
        signal_new = signal_new./max(abs(signal_new));                      %归一化
        [rmsEVM,maxEVM,pctEVM,numSym] = evm(signal_raw,signal_new);         %评估指标
        if rmsEVM >= 0.005
            disp(['极限 -> 截位: ' num2str(cut_N) ' 建议截位小于这个值']);
            disp('---------------------------------------------------------')
            disp(['平均情况 rmsEVM = ' num2str(rmsEVM) '%'])
            disp(['最差的点 maxEVM = ' num2str(maxEVM) '%'])
            disp(['≤95% pctEVM = ' num2str(pctEVM) '%'])
            disp(['numSym = ' num2str(numSym)])
            disp('---------------------------------------------------------')
            break
        else
            disp(['截位: ' num2str(cut_N)]);
            disp('---------------------------------------------------------')
            disp(['平均情况 rmsEVM = ' num2str(rmsEVM) '%'])
            disp(['最差的点 maxEVM = ' num2str(maxEVM) '%'])
            disp(['≤95% pctEVM = ' num2str(pctEVM) '%'])
            disp(['numSym = ' num2str(numSym)])
            disp('---------------------------------------------------------')
            cut_N = cut_N + 1;
        end
    end


else 
    cut_N = abs(cut_N);
    disp(['手动截位模式 截位前:' num2str(signal.WordLength) ' 截位:' num2str(cut_N) ' 截位后:' num2str(signal.WordLength-cut_N)])
    %----------------------------------------------------------------------
    signal_raw = double(signal(:));                                     %装入数据
    signal_new = cut_function(signal_raw,cut_N);                        %截位后
    signal_raw = signal_raw./max(abs(signal_raw));                      %归一化
    signal_new = signal_new./max(abs(signal_new));                      %归一化
    [rmsEVM,maxEVM,pctEVM,numSym] = evm(signal_raw,signal_new);         %评估指标
    disp('---------------------------------------------------------')
    disp(['截位: ' num2str(cut_N)]);
    disp('---------------------------------------------------------')
    disp(['平均情况 rmsEVM = ' num2str(rmsEVM) '%'])
    disp(['最差的点 maxEVM = ' num2str(maxEVM) '%'])
    disp(['≤95% pctEVM = ' num2str(pctEVM) '%'])
    disp(['numSym = ' num2str(numSym)])
    disp('---------------------------------------------------------')

end


out = fi(cut_function(signal,cut_N),signal.Signed,signal.WordLength-cut_N,0);
if nargout == 0
figure(1);
subplot(121);p3(signal_raw);hold on
p3(signal_new,'--');hold off;grid on
subplot(122);
plot(db(fft(signal_raw)));hold on;
plot(db(fft(signal_new)),'--');grid on;hold off
xlim([-numel(signal_raw)*0.02 numel(signal_raw)*1.02]);
end
end

function p3(signal,mark)
    if nargin==2
        plot3(1:size(signal,1),real(signal),imag(signal),mark);grid on
        xlabel('点数');ylabel('实部');zlabel('虚部')
    elseif nargin ==1
        plot3(1:size(signal,1),real(signal),imag(signal));grid on
        xlabel('点数');ylabel('实部');zlabel('虚部')
    end
end