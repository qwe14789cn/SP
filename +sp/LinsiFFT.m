%--------------------------------------------------------------------------
%   某个AD测试复制过来的ADC性能分析代码，还没研究注释其测试效果
%   未完成->打算与函数ad_analyzer整合
%--------------------------------------------------------------------------
function [ENOB, SINAD, SFDR, SNR] = LinsiFFT(Dout,fclk)

       
%   Recenter the digital sine wave
    %Dout=Dout-(2^numbit-1)/2;
    Dout=Dout-mean(Dout); 
    numpt=length(Dout);
    har_N=9;
 % Plot results in the time domain


    %If no window function is used, the input tone must be chosen to be unique and with
    %regard to the sampling frequency. To achieve this prime numbers are introduced and the
    %input tone is determined by fIN = fSAMPLE * (Prime Number / Data Record Size).
    %To relax this requirement, window functions such as HANNING and HAMING (see below) can
    %be introduced, however the fundamental in the resulting FFT spectrum appears 'sharper'
    %without the use of window functions.

 
    Doutw=Dout.*blackmanharris(numpt);

    %Performing the Fast Fourier Transform
    Dout_spect=fft(Doutw);
    Dout_spect(1:3)=0;
   % Dout_spect(numpt/2-4:numpt/2)=0;
    %Recalculate to dB
    Dout_dB=20*log10(abs(Dout_spect));
    maxdB=max(Dout_dB(1:numpt/2));
  %Span of the input frequency on each side
    span=max(round(numpt/200),5);    % default (numpt/200,5)
    span=5;
    %Calculate SNR, SINAD, THD and SFDR values
    %Find the signal bin number, DC = bin 1
    fin=find(Dout_dB(1:numpt/2)==maxdB);
    Dout_dB_tmp=[Dout_dB(1:fin-span); Dout_dB(fin+span:numpt/2)];
    Sec_maxdB=max(Dout_dB_tmp(1:end));
  
    %Determine power spectrum
    spectP=(abs(Dout_spect)).*(abs(Dout_spect));
   
   
    %Find DC offset power
    Pdc=sum(spectP(1:span));
    %Extract overall signal power
    Ps=sum(spectP(fin-span:fin+span));
    %Vector/matrix to store both frequency and power of signal and harmonics
    Fh=[];
    %The 1st element in the vector/matrix represents the signal, the next element represents
    %the 2nd harmonic, etc.
    Ph=[];
  %Approximate search span for harmonics on each side
    spanh=5;
    %Find harmonic frequencies and power components in the FFT spectrum
    for har_num=1:har_N
    %Input tones greater than fSAMPLE are aliased back into the spectrum
    tone=rem((har_num*(fin-1)+1)/numpt,1);
    if tone>0.5
    %Input tones greater than 0.5*fSAMPLE (after aliasing) are reflected
    tone=1-tone;
    end
    Fh=[Fh tone];
    %For this procedure to work, ensure the folded back high order harmonics do not overlap
    %with DC or signal or lower order harmonics
     index_tmp=round(tone*numpt)-spanh;
    if index_tmp<1
        index_tmp=1;
    end
    har_peak=max(spectP(index_tmp:round(tone*numpt)+spanh));
    har_bin=find(spectP(index_tmp:round(tone*numpt)+spanh)==har_peak);
    har_bin=har_bin+round(tone*numpt)-spanh-1;
    if har_bin<2
        har_bin=2;
    end
    Ph=[Ph sum(spectP(har_bin-1:har_bin+1))];
    end
    %Determine the total distortion power
    Pd=sum(Ph(2:har_N));
    %Determine the noise power
    Pn=sum(spectP(1:numpt/2))-Ps-Pd;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    format;
    A=(max(Dout)-min(Dout))/2;
    SINAD=10*log10(Ps/(Pn+Pd));
    ENOB=(SINAD-1.76)/6.02;
    SNR=10*log10(Ps/Pn);
    %THD is calculated from 2nd through 5th order harmonics
    THD=10*log10(Pd/Ph(1));
    SFDR=maxdB-Sec_maxdB;
    %Signal & Harmonic Power Components
    HD=10*log10(Ph(1:har_N)/Ph(1));

    %Display the results in the frequency domain with an FFT plot

    fclk=fclk/1e6; % change Mhz to Khz
    FFin=fin/numpt*fclk;
    fin_dis=round(FFin*10)/10;
    SINAD_dis=round(SINAD*100)/100;
    ENOB_dis=round(ENOB*100)/100;
    SFDR_dis=round(SFDR*100)/100;
    SNR_dis=round(SNR*100)/100;
    %For TTIMD, use the following short routine, normalized to 锟?.5dB full-scale.
   
    set (gcf,'Position',[10,10,650,400]);
    set(gca,'fontsize', 14);
    %plot([1:numpt/2].*fclk/numpt,Dout_dB(1:numpt/2)-maxdB);
    stem([0:numpt/2-1].*fclk/numpt,Dout_dB(1:numpt/2)-maxdB,'LineWidth',1.5,'BaseValue',-120);
    set(gca,'FontSize',14,'FontWeight','bold'); 
    grid on;
    %title('FFT PLOT');
    xlabel('Frequency [MHz]', 'fontsize', 16,'fontweight', 'bold');
    ylabel('[dB]', 'fontsize', 16,'fontweight', 'bold');
    a1=axis; 
    axis([a1(1) fclk/2 -120 a1(4)]);
    %text(10,-10,['SINAD=',num2str(SINAD) ' ','ENOB=' num2str(ENOB) ' ','SFDR=' num2str(SFDR)  '    ','FFT--' num2str(numpt)], 'fontsize', 12, 'fontweight', 'bold');
    %text(fclk/4-14*fclk/100,-6,[num2str(numbit) '-bit' '  mode' ], 'fontsize', 14, 'fontweight', 'bold');
    text(fclk/3-14*fclk/100,-6,['fs=',num2str(fclk) 'MS/s' ], 'fontsize', 16, 'fontweight', 'bold');
    text(fclk/3-14*fclk/100,-14,['fin=',num2str(fin_dis) 'MHz' ], 'fontsize', 16, 'fontweight', 'bold');
    %text(fclk/4-14*fclk/100,-42,['SNR=' num2str(SNR_dis) 'dB'], 'fontsize', 14, 'fontweight', 'bold');
    text(fclk/3-14*fclk/100,-22,['SNDR=' num2str(SINAD_dis) 'dB' ], 'fontsize', 16, 'fontweight', 'bold');
    text(fclk/3-14*fclk/100,-30,['ENOB=' num2str(ENOB_dis) 'bit'], 'fontsize', 16, 'fontweight', 'bold');
    text(fclk/3-14*fclk/100,-38,['SFDR=' num2str(SFDR_dis) 'dB'], 'fontsize', 16, 'fontweight', 'bold');
    text(fclk/3-14*fclk/100,-46,['FFT--' num2str(numpt)], 'fontsize', 16, 'fontweight', 'bold')
    
    disp('----LX08D1000 ADC Testing Results----');
    dispstr=strcat('ENOB =',char(20),num2str(ENOB),' bits');
    disp(dispstr);
    dispstr=strcat('SINAD =',char(20),num2str(SINAD),' dB');
    disp(dispstr);
    dispstr=strcat('SNR =',char(20),num2str(SNR),' dB');
    disp(dispstr);
    dispstr=strcat('SFDR =',char(20),num2str(SFDR),' dB');
    disp(dispstr);
    disp('THD is calculated from 2nd through 5th order harmonics');
    dispstr=strcat('THD =',char(20),num2str(THD),' dB');
    disp(dispstr);
    dispstr=strcat('HD(1st~9th) in dB =',char(20),num2str(HD));
    disp(dispstr);
