%--------------------------------------------------------------------------
%   output = complex_randn(varargin)
%--------------------------------------------------------------------------
%   功能：
%   复噪声高斯分布随机生成器,单位为1
%--------------------------------------------------------------------------
%   输入：
%           varargin          数据长度
%--------------------------------------------------------------------------
%   例子：
%   complex_randn(5)
%   complex_randn(10,20)
%--------------------------------------------------------------------------
function output = complex_randn(varargin)
str_input = [];
for idx = 1:nargin
    if idx == nargin
        str_input = [str_input num2str(varargin{idx})];
    else
        str_input = [str_input num2str(varargin{idx}),','];
    end
end

output = eval(['1/sqrt(2).*(randn([' str_input '])+1j.*randn([' str_input ']))']);
    
end