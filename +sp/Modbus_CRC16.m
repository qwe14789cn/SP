function [ CRC ] = Modbus_CRC16( Data_Modbus )
%   8 bit MODBUS_CRC Calculation
%   Data_Modbus is the Data to Generate the Value of Modbus_CRC16,and it is
%   8 bit type
CRC = uint16(hex2dec('FFFF')); %0xFFFF, initial value
CRC_poly = uint16(hex2dec('A001')); %the Polynomial is 0xA001 
for i = 1:length(Data_Modbus)
    CRC = bitxor(CRC,uint16(Data_Modbus(i)));
    for k = 1:8
        if(bitand(CRC,hex2dec('0001')))
            CRC = bitsrl(CRC,1);
            CRC = bitxor(CRC, CRC_poly);
        else
            CRC = bitsrl(CRC,1);
        end
    end
    
end
CRC = typecast(CRC,'uint8');
end

