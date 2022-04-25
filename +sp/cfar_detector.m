%--------------------------------------------------------------------------
%   [detected,th] = cfar_detector(sig,pfa,train)
%--------------------------------------------------------------------------
%   功能：
%   奈曼皮尔逊检测器，一维恒虚警检测器，在MTD平面中检测点目标回波信号
%   cfar_detector 形态
%   □□□□□■■◎■■□□□□□
%   □   训练单元
%   ■   守护单元
%   ◎   判决检测
%--------------------------------------------------------------------------
%   输入:
%   sig         数据 列表示距离维 注意输入信号为 功率信号
%   pfa         虚警概率
%   shape       训练单元 守护单元 判决点 守护单元 训练单元
%   输出:
%   detected    判决平面
%   th          判决阈值
%--------------------------------------------------------------------------
%   例子：
%   [detected,th] = cfar_detector(sig,[1e-5 1e-3],[8 3 1 3 8])
%--------------------------------------------------------------------------
function [detected,th] = cfar_detector(sig,pfa,train)
tL = train(1);                                                              %左侧训练
gL = train(2);                                                              %左侧守护
gR = train(end-1);                                                          %右侧守护
tR = train(end);                                                            %右侧训练
L = length(sig);
N = tL + tR;

pfa = linspace(pfa(1),pfa(2),L);
aL = tL*(pfa.^(-1./tL)-1);
aR = tR*(pfa.^(-1./tR)-1);
a  = N*(pfa.^(-1./N)-1);

th = zeros(L,1);

for idx = 1:L
    Ls = idx-gL-tL;                                                         %左侧起始坐标
    Ln = idx-gL-1;                                                          %左侧结束坐标
    Rs = idx+gR+1;                                                          %右侧起始坐标
    Rn = idx+gR+tR;                                                         %右侧结束坐标

    if Ls<=0                                                                %左侧坐标不够
        train = sig(Rs:Rn);                                                 %右侧训练
        th(idx,:) = aR(idx).*mean(train);
    elseif Rn>=L                                                            %右侧坐标不够
        train = sig(Ls:Ln);                                                 %左侧训练
        th(idx,:) = aL(idx).*mean(train);
    else
        train = [sig(Ls:Ln);sig(Rs:Rn)];
        th(idx,:) = a(idx).*mean(train);
    end
end
detected = sig>th;
end
