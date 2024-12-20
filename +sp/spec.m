%--------------------------------------------------------------------------
%   spec(sig,fs,Nfft,select)
%--------------------------------------------------------------------------
%   ���ܣ�
%   �ź�Ƶ�׷������ߣ����ڷ����źŵķ�Ƶ��Ӧ����Ƶ��Ӧ��������Ӧ
%--------------------------------------------------------------------------
%   ���룺
%           sig             ԭʼ�ź�
%           fs              ��������
%           Nfft            fft����
%           select          ѡ��������λֵ       
%--------------------------------------------------------------------------
%   ���ӣ�
%   spec(sig)
%   spec(sig,fs)                    ��ָ��fft����
%   spec(sig,fs,nfft)               ָ��fft����
%   spec(sig,fs,[],select)          ���ָ��������λֵ
%   spec(sig,fs,nfft,select)        ���ָ��������λֵ
%--------------------------------------------------------------------------
function spec(sig,fs,Nfft,select)
sig = double(sig(:));

if nargin == 1
    fs = [];                                                                %��һ��Ƶ��
    N2 = nextpow2(length(sig));
    Nfft = 2^N2;
elseif nargin == 2
    N2 = nextpow2(length(sig));
    Nfft = 2^N2;
end
if isempty(Nfft)
    Nfft = 2^nextpow2(length(sig));
end

if isempty(fs)
    fs = 1;
end

%   ��λת��
[value,~,unit] = signalwavelet.internal.convenienceplot.getFrequencyEngUnits(fs);
disp('--------------------')
if isreal(sig)
    disp('ʵ�ź�:')
else
    disp('���ź�:')
end

disp([' length -> ' num2str(numel(sig))])
disp([' NFFT   -> ' num2str(Nfft)]);
disp('--------------------')
%--------------------------------------------------------------------------
%   �����ʵ�ź�
%--------------------------------------------------------------------------
if isreal(sig)
    f = linspace(0,value/2-value/Nfft,Nfft/2);
    A = fft(sig,Nfft);
    A = A(1:Nfft/2);
    %----------------------------------------------------------------------
    subplot(2,3,[1 2]);plot(f,mag2db(abs(A)));
    if nargin == 1
        xlabel('��һ��Ƶ��');ylabel('���� dB');grid on
        title('ʵ�źŷ�Ƶ��Ӧ')
    else
        xlabel(['Ƶ��' unit]);ylabel('���� dB');grid on
        title(['��������' num2str(value) ' ' unit 'ʵ�źŷ�Ƶ��Ӧ'])
    end
    %----------------------------------------------------------------------
    subplot(2,3,[4 5]);plot(f,rad2deg(angle(A)));
    if nargin == 1
        xlabel('��һ��Ƶ��');ylabel('���� dB');grid on
        title('ʵ�ź���Ƶ��Ӧ')
    else
        xlabel(['Ƶ��' unit]);ylabel('���� dB');grid on
        title(['��������' num2str(value) ' ' unit 'ʵ�ź���Ƶ��Ӧ'])
    end
    %----------------------------------------------------------------------


    subplot(2,3,[3 6]);
    plot3(1:length(A),real(A),imag(A));grid on
    xlabel('����');ylabel('ʵ��');zlabel('�鲿')
    axis([0 length(A) -max(abs(A(:))) max(abs(A(:))) -max(abs(A(:))) max(abs(A(:)))])
    %----------------------------------------------------------------------
    if nargin <=3                                                           %��������� �Զ�Ѱ�����ֵ
        select = find(A==max(A(:)));
        ang = rad2deg(angle(A(select)));
        title(['Ƶ�� ' num2str(f(select)) unit ' ��λΪ ' num2str(ang) ' ��']);
    end
    if nargin == 4                                                          %��������� �Զ�Ѱ�����ֵ
        ang = rad2deg(angle(A(select)));
        title(['�� ' num2str(select) ' ��λΪ ' num2str(ang) ' ��']);
    end
%--------------------------------------------------------------------------
%   ����Ǹ��ź�
%--------------------------------------------------------------------------
else                                                                        %���źŷ��������߹�����
    f = linspace(0,value-value/Nfft,Nfft);
    A = fft(sig,Nfft);
    %----------------------------------------------------------------------
    subplot(2,3,[1 2]);plot(f,mag2db(abs(A)));

    if nargin == 1
        xlabel('��һ��Ƶ��');ylabel('���� dB');grid on
        title('���źŷ�Ƶ��Ӧ')
    else
        xlabel(['Ƶ��' unit]);ylabel('���� dB');grid on
        title(['��������' num2str(value) ' ' unit '���źŷ�Ƶ��Ӧ'])
    end
    %----------------------------------------------------------------------
    subplot(2,3,[4 5]);plot(f,rad2deg(angle(A)));
    if nargin == 1
        xlabel('��һ��Ƶ��');ylabel('���� dB');grid on
        title('ʵ�ź���Ƶ��Ӧ')
    else
        xlabel(['Ƶ��' unit]);ylabel('��λ ��');ylim([-190 190]);grid on
        title(['��������' num2str(value) ' ' unit '���ź���Ƶ��Ӧ'])
    end
    subplot(2,3,[3 6]);
    plot3(1:length(A),real(A),imag(A));grid on
    xlabel('����');ylabel('ʵ��');zlabel('�鲿');
    axis([0 length(A) -max(abs(A(:))) max(abs(A(:))) -max(abs(A(:))) max(abs(A(:)))])
    %----------------------------------------------------------------------
    if nargin <=3                                                           %��������� �Զ�Ѱ�����ֵ
        select = find(A==max(A(:)));
        ang = rad2deg(angle(A(select)));
        title(['Ƶ�� ' num2str(f(select)) unit ' ��λΪ ' num2str(ang) ' ��']);
    end

    if nargin == 4
        ang = rad2deg(angle(A(select)));
        title(['�� ' num2str(select) ' ��λΪ ' num2str(ang) ' ��']);
    end
end