%--------------------------------------------------------------------------
%   [detected,th] = pow2cfar(datain,pfa,guard_N,train_N)
%--------------------------------------------------------------------------
%   功能：
%   奈曼皮尔逊检测器，matlab自带官方版
%--------------------------------------------------------------------------
%   输入:
%           datain              数据 列表示距离维
%           pfa                 虚警概率
%           train_N             训练单元点数,单边
%           guard_N             守护单元点数,单边
%   输出:
%           detected            判决结果
%           th                  判决阈值
%--------------------------------------------------------------------------
%   p2cfar形态
%   □□□□□■■◎■■□□□□□
%   □   训练单元
%   ■   守护单元
%   ◎   判决检测
%--------------------------------------------------------------------------
%   例子：
%   [detected,th] = p2cfar(datain,pfa,train_N,guard_N)
%--------------------------------------------------------------------------
function [detected,th] = pow2cfar(datain,pfa,guard_N,train_N)
cfar = phased.CFARDetector('NumTrainingCells',train_N*2,'NumGuardCells',guard_N*2);
cfar.ProbabilityFalseAlarm = pfa;
cfar.ThresholdOutputPort = true;
cfar.ThresholdFactor = 'Auto';
[detected,th] = cfar(datain,1:size(datain,1));
