%--------------------------------------------------------------------------
%   d = read_serialdata(comname,rate,len,head)
%--------------------------------------------------------------------------
%   功能：
%   串口数据读取
%--------------------------------------------------------------------------
%   输入:
%           comname         串口号
%           rate            波特率
%           len             数据长度
%           head            串口帧头
%--------------------------------------------------------------------------
%   例子:
%   data = read_serialdata("COM4",115200,26,hex2dec(["55" "AA" "DC"]))
%--------------------------------------------------------------------------
function d = read_serialdata(comname,rate,len,head)
s = serialport(comname,rate);
configureTerminator(s,"CR/LF"); 
flush(s);
data = read(s,len*2,"uint8");
h = sp.findhead(data,head);
d = data(h(1):h(1)+len-1);
end