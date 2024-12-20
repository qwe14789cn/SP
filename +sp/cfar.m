%--------------------------------------------------------------------------
%   [detected,th] = cfar(sig,K,D,shape,option)
%--------------------------------------------------------------------------
%   功能：
%   奈曼皮尔逊检测器，一维恒虚警检测器，在回波信号中检测点目标
%   □□□□□■■◎■■□□□□□
%   □       训练单元
%   ■       守护单元
%   ◎      判决检测
%--------------------------------------------------------------------------
%   支持      CA-CFAR(cell-average)
%   支持      SO-CFAR(smallest of)
%   支持      GO-CFAR(greatest of)
%   不支持    WCA-CFAR(weighted cell average)
%--------------------------------------------------------------------------
%   输入:
%   sig         数据 列表示距离维 注意输入信号为 功率信号
%   K         	方差
%   D           直流
%   shape       训练单元 守护单元 判决点 守护单元 训练单元
%   输出:
%   detected    判决平面
%   th          判决阈值
%--------------------------------------------------------------------------
%   例子：
%   [detected,th] = cfar(sig,0.5,0,[8 3 1 3 8],'ca')
%   [detected,th] = cfar(sig,0.5,0,[8 3 1 3 8],'so')
%   [detected,th] = cfar(sig,0.5,0,[8 3 1 3 8],'go')
%--------------------------------------------------------------------------
function [detected,th] = cfar(sig,K,D,shape,option)
if nargin <=4
    option = 'CA';
end
option = upper(option);                                                     %全大写

disp(['当前配置为 ' option '-CFAR 检测器']);

tL = shape(1);                                                              %左侧训练
gL = shape(2);                                                              %左侧守护
gR = shape(end-1);                                                          %右侧守护
tR = shape(end);                                                            %右侧训练

[I,J] = size(sig);
th = zeros(I,J);


for jdx = 1:J
    for idx = tL + gL + 1:I - tR - gR
	    temp = sig(idx-tL-gL:idx+tR+gR,jdx);

        powL = mean(temp(1:tL));
        powR = mean(temp(end-tR+1:end));
        
        switch option
            case 'CA'
                Pow = (powL + powR)/2;
            case 'SO'
                Pow = min(powL,powR);
            case 'GO'
                Pow = max(powL,powR);
%             case 'wca'
%                 Pow = a*powL+b*powR;
        end
        th(idx,jdx) = K.*Pow+D;
    end
    th(1:tL+gL,jdx) = th(tL + gL + 1,jdx);
    th(I-tR-gR:end,jdx) = th(I-tR-gR,jdx);
end
detected = sig > th;
