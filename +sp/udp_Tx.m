%--------------------------------------------------------------------------
%   udp_Tx(dataSend,IP,IPport)
%--------------------------------------------------------------------------
%   功能：
%   udp数据发送函数
%--------------------------------------------------------------------------
%   输入：
%           dataSend            待发送数据,要考虑数据格式
%           IP                  接收方IP地址
%           IPport              接收方端口号
%           BufferSize          数据缓冲长度
%--------------------------------------------------------------------------
%   例子：
%   udp_Tx(uint8([1 2 3]),'192.168.1.1',31000,3)
%   udp_Tx(single([1 2 3]),'192.168.1.1',31000,640)
%--------------------------------------------------------------------------
function udp_Tx(dataSend,IP,IPport,BufferSize)
if nargin<=3
    BufferSize = 8192;
end
udpTx = dsp.UDPSender('RemoteIPAddress',IP,'RemoteIPPort',IPport,'SendBufferSize',BufferSize);
%   判断数据是否需要分割
M = fix(length(dataSend)/BufferSize);
N = rem(length(dataSend),BufferSize);
for idx = 1:M
    udpTx(dataSend((idx-1)*BufferSize+1:idx*BufferSize));
end
if N~=0
    udpTx(dataSend(M*BufferSize+1:end));
end
release(udpTx);
end
