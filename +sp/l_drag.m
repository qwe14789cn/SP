%--------------------------------------------------------------------------
%   L_drag = l_drag(L,drag_N)
%--------------------------------------------------------------------------
%   功能：
%   logical二值拖拽函数,将第一个检测的1点向后拖拽N倍
%--------------------------------------------------------------------------
%   输入：
%           L               logical二值化后的信号
%           drag_N          拖拽点数长度
%--------------------------------------------------------------------------
%   输出：
%           L_drag          拖拽后的输出
%--------------------------------------------------------------------------
%   例子:
%   L_drag = pulse_drag(L,20)
%--------------------------------------------------------------------------
function L_drag = l_drag(L,drag_N)
L_drag = L;
flag = 0;                                                                   %起始1标记位
en = 0;
for jdx = 1:size(L,2)
    for idx = 1:size(L,1)
        if L(idx,jdx) == 1 && flag ==0                                      %检测到1 改变工作状态
            flag = 1;
            %--------------------------------------------------------------
            %   信号没有尾巴
            %--------------------------------------------------------------
            if idx+drag_N-1<size(L,1)
                L_drag(idx:idx+drag_N-1,jdx) = 1;
                en = idx+drag_N-1;
                %----------------------------------------------------------
                %   信号尾巴截断
                %----------------------------------------------------------
            else
                L_drag(idx:end,jdx) = 1;
                en = size(L,2);
            end
            
        end
        if idx>=en && flag ==1
            flag = 0;
        end
        
        
    end
end

end