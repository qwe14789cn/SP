%--------------------------------------------------------------------------
%   Received = udp_Rx(port,package_size)
%--------------------------------------------------------------------------
%   功能：
%   udp数据接收函数
%--------------------------------------------------------------------------
%   输入：
%           port                端口号
%           package_size        数据包大小格式
%           data_type           数据形式
%--------------------------------------------------------------------------
%   例子：
%   R = udp_Rx(1234,[10,5],'uint8')
%--------------------------------------------------------------------------
function Received = udp_Rx(port,package_size,data_type)
udpRx = dsp.UDPReceiver('MessageDataType',data_type);
udpRx.LocalIPPort = port;
udpRx.ReceiveBufferSize = 65536;
udpRx.MaximumMessageLength = package_size(1);
TOTAL = package_size(2);
Received = zeros(package_size(1),package_size(2));
eval(['Received = ' data_type '(Received);']);
while TOTAL
    Rx = udpRx();
    if ~isempty(Rx)
        Received(:,package_size(2)-TOTAL+1) = Rx;
        TOTAL = TOTAL - 1;
    end
end
release(udpRx);
