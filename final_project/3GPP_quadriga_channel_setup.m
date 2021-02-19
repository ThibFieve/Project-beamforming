%function [quad_layout,Geometry,chan,chOut, DoAEstimation] = TrialCreateScenarioAndVisualize_quadriga(Geometry,Pars,Rapidchannel)
%LOS with OFDM waveforms and quadriga channel
% Create Layout Object
quad_layout = qd_layout;
%Set scenario parameters
quad_layout.set_scenario('QuaDRiGa_UD2D_LOS'); %LOS model is used
quad_layout.simpar.center_frequency = Pars.fc; % carrier frequency
txArr = qd_arrayant('omni'); %tx antennas omnidirectional
rxArr = qd_arrayant('omni'); %rx antennas omnidirectional
rxArr.no_elements=Pars.nant; % 4X4 antenna array at rx
rxArr.element_position=Geometry.BSAntennaPos;%define BS position
% Set geometry to quadriga layout
quad_layout.tx_array = txArr; % parameters of tx  
quad_layout.rx_array = rxArr; % parameters of rx
quad_layout.no_rx=1; % there is 1 BS
quad_layout.no_tx=4; % there are 4 users
tx_track1 = qd_track('linear',Geometry.T1,pi/2);
tx_track1.name='trackV1';
tx_track2 = qd_track('linear',Geometry.T2,pi); %angle !!!!!!!!
tx_track2.name='trackV2';
tx_track1.initial_position = Geometry.V1PosStart';
%tx_track1.positions=[Geometry.V1PosEnd'];
tx_track2.initial_position = Geometry.V2PosStart';
%tx_track2.positions=[Geometry.V2PosEnd'];;
quad_layout.tx_position=[Geometry.V1PosStart',Geometry.V2PosStart',...
   Geometry.I1Pos',Geometry.I2Pos'];
quad_layout.tx_track(1,1)=copy(tx_track1);
quad_layout.tx_track(1,2)=copy(tx_track2);
quad_layout.rx_position=Geometry.BSPos';
%quad_layout.visualize();
quad_layout.set_pairing;
chan = quad_layout.get_channels;
%%
selected_chan1=chan(1);%channel for vehicle1
selected_chan1.name,    
coefficients1 = selected_chan1.coeff;
whos coefficients1,
chTaps1=size(selected_chan1.delay);%numberof antennas,1,numberof delay paths,number of discretizedpositions
ofdmMod1 = comm.OFDMModulator('FFTLength', Pars.fftlen, ...
   'NumGuardBandCarriers', [Pars.ngsc;Pars.ngsc], ...
   'InsertDCNull', false, ...
   'CyclicPrefixLength', [Pars.cplen], ...
   'Windowing', false, ...
   'NumSymbols', Pars.numsymbols, ...
   'NumTransmitAntennas', 1, ...
   'PilotInputPort', false);
ofdmInfo = info(ofdmMod1);
ofdmSize = ofdmInfo.DataInputSize;
Fs = Pars.fftlen*15000;% sample rate with 15Khz subcarrier spacing
in1 = randi([0 1], ofdmSize(1)*ofdmSize(2)*log2(Pars.M), 1);% input bits vehicle1
dataInput1 = qammod(in1, Pars.M, 'bin', 'InputType', 'bit', 'UnitAveragePower', true);%qam modulator
dataInput1 = reshape(dataInput1, ofdmSize);% 
waveform1 = ofdmMod1(dataInput1);% waveform
ofdmDemod1=comm.OFDMDemodulator(ofdmMod1);%demodulator
TS=1/Fs;% sample time
WFlength=size(waveform1);
chOut1=zeros(chTaps1(1),WFlength(1));
TsVect=0:TS:TS*(WFlength(1)-1);
%for antenna=1:1:chTaps1(1)
%    for path=1:1:chTaps1(3)
%        inX1=TsVect-selected_chan1.delay(antenna,1,path,1);
%        inY1=interp1(TsVect,waveform1,inX1,'pchip');
%        chOut1(antenna,:)=inY1*selected_chan1.coeff(antenna,1,path,1)...
%        +chOut1(antenna,:);
%    end
%end %generates the output of the channel(signal received by BS)
%datastream vehicle2
selected_chan2=chan(2);
selected_chan2.name,    
coefficients2 = selected_chan2.coeff;
whos coefficients2,
chTaps2=size(selected_chan2.delay);
ofdmMod2 = comm.OFDMModulator('FFTLength', Pars.fftlen, ...
   'NumGuardBandCarriers', [Pars.ngsc;Pars.ngsc], ...
   'InsertDCNull', false, ...
   'CyclicPrefixLength', [Pars.cplen], ...
   'Windowing', false, ...
   'NumSymbols', Pars.numsymbols, ...
   'NumTransmitAntennas', 1, ...
   'PilotInputPort', false);
ofdmInfo = info(ofdmMod2);
ofdmSize = ofdmInfo.DataInputSize;
in2 = randi([0 1], ofdmSize(1)*ofdmSize(2)*log2(Pars.M), 1);
dataInput2 = qammod(in2, Pars.M, 'bin', 'InputType', 'bit', 'UnitAveragePower', true);
dataInput2 = reshape(dataInput2, ofdmSize);
waveform2 = ofdmMod2(dataInput2);
ofdmDemod2=comm.OFDMDemodulator(ofdmMod2);
chOut2=zeros(chTaps2(1),WFlength(1));      
%for antenna=1:1:chTaps2(1)
%    for path=1:1:chTaps2(3)
%        inX2=TsVect-selected_chan2.delay(antenna,1,path,1);
%        inY2=interp1(TsVect,waveform2,inX2,'pchip');
%        chOut2(antenna,:)=inY2*selected_chan2.coeff(antenna,1,path,1)...
%        +chOut2(antenna,:);
%    end
%end
%datastream interferer1
selected_chan3=chan(3);
selected_chan3.name,    
coefficients3 = selected_chan3.coeff;
whos coefficients3,
chTaps3=size(selected_chan3.delay);
ofdmMod3 = comm.OFDMModulator('FFTLength', Pars.fftlen, ...
   'NumGuardBandCarriers', [Pars.ngsc;Pars.ngsc], ...
   'InsertDCNull', false, ...
   'CyclicPrefixLength', [Pars.cplen], ...
   'Windowing', false, ...
   'NumSymbols', Pars.numsymbols, ...
   'NumTransmitAntennas', 1, ...
   'PilotInputPort', false);
ofdmInfo = info(ofdmMod3);
ofdmSize = ofdmInfo.DataInputSize;
in3 = randi([0 1], ofdmSize(1)*ofdmSize(2)*log2(Pars.M), 1);
dataInput3 = qammod(in3, Pars.M, 'bin', 'InputType', 'bit', 'UnitAveragePower', true);
dataInput3 = reshape(dataInput3, ofdmSize);
waveform3= ofdmMod3(dataInput3);
ofdmDemod3=comm.OFDMDemodulator(ofdmMod3);
chOut3=zeros(chTaps3(1),WFlength(1));
%for antenna=1:1:chTaps3(1)
%    for path=1:1:chTaps3(3)
%        inX3=TsVect-selected_chan3.delay(antenna,1,path);
%        inY3=interp1(TsVect,waveform3,inX3,'pchip');
%        chOut3(antenna,:)=inY3*selected_chan3.coeff(antenna,1,path)...
%        +chOut3(antenna,:);
%    end
%end
%datastream interferer2
selected_chan4=chan(4);
selected_chan4.name,    
coefficients4= selected_chan4.coeff;
whos coefficients4,
chTaps4=size(selected_chan4.delay);
ofdmMod4 = comm.OFDMModulator('FFTLength', Pars.fftlen, ...
   'NumGuardBandCarriers', [Pars.ngsc;Pars.ngsc], ...
   'InsertDCNull', false, ...
   'CyclicPrefixLength', [Pars.cplen], ...
   'Windowing', false, ...
   'NumSymbols', Pars.numsymbols, ...
   'NumTransmitAntennas', 1, ...
   'PilotInputPort', false);
ofdmInfo = info(ofdmMod4);
ofdmSize = ofdmInfo.DataInputSize;
in4 = randi([0 1], ofdmSize(1)*ofdmSize(2)*log2(Pars.M), 1);
dataInput4 = qammod(in4, Pars.M, 'bin', 'InputType', 'bit', 'UnitAveragePower', true);
dataInput4 = reshape(dataInput4, ofdmSize);
waveform4 = ofdmMod4(dataInput4);
ofdmDemod4=comm.OFDMDemodulator(ofdmMod4);
chOut4=zeros(chTaps4(1),WFlength(1));
positionvect1=[];%positions of the vehicle1
positionvect2=[];%positions of the vehicle2
BERvect1=[];%BER for vehicle1
BERvect2=[];%BER for vehicle2
for n=1:Pars.numpositions
    positionvect1(n)=floor((n-1)*(length(selected_chan1.tx_position)-1)/(Pars.numpositions-1))+1;
    positionvect2(n)=floor((n-1)*(length(selected_chan2.tx_position)-1)/(Pars.numpositions-1))+1;
end
for antenna=1:1:chTaps3(1)
    for path=1:1:chTaps3(3)
        inX3=TsVect-selected_chan3.delay(antenna,1,path);
        inY3=interp1(TsVect,waveform3,inX3,'pchip');
        chOut3(antenna,:)=inY3*selected_chan3.coeff(antenna,1,path)...
        +chOut3(antenna,:);
    end
end
for antenna=1:1:chTaps4(1)
    for path=1:1:chTaps4(3)
        inX4=TsVect-selected_chan4.delay(antenna,1,path);
        inY4=interp1(TsVect,waveform4,inX4,'pchip');
        chOut4(antenna,:)=inY4*selected_chan4.coeff(antenna,1,path)...
        +chOut4(antenna,:);
    end
end

for step=1:length(positionvect1)
for antenna=1:1:chTaps1(1)
    for path=1:1:chTaps1(3)
        inX1=TsVect-selected_chan1.delay(antenna,1,path,positionvect1(step));
        inY1=interp1(TsVect,waveform1,inX1,'pchip');
        chOut1(antenna,:)=inY1*selected_chan1.coeff(antenna,1,path,positionvect1(step))...
        +chOut1(antenna,:);
    end
end
for antenna=1:1:chTaps2(1)
    for path=1:1:chTaps2(3)
        inX2=TsVect-selected_chan2.delay(antenna,1,path,positionvect2(step));
        inY2=interp1(TsVect,waveform2,inX2,'pchip');
        chOut2(antenna,:)=inY2*selected_chan2.coeff(antenna,1,path,positionvect2(step))...
        +chOut2(antenna,:);
    end
end
chOut=chOut1+chOut2+chOut3+chOut4;
chOut=awgn(chOut,Pars.SNR,'measured');
chOut=chOut.';
%pos1=transpose(selected_chan1.tx_position(:,randindex1(step)));
%AOAV1=atan2(Geometry.BSPos(1,2)-pos1(1,2),...
%   Geometry.BSPos(1,1)-pos1(1,1))*180/pi;
%ZOAV1=atan2(sqrt(sum((pos1(1,1:2)-Geometry.BSPos(1,1:2)).^2)),...
%   Geometry.BSPos(1,3)-pos1(1,3))*180/pi;
%AOAV2=atan2(Geometry.BSPos(1,2)-pos2(1,2),...
%   Geometry.BSPos(1,1)-pos2(1,1))*180/pi;
%ZOAV2=atan2(sqrt(sum((pos2(1,1:2)-Geometry.BSPos(1,1:2)).^2)),...
%   Geometry.BSPos(1,3)-pos2(1,3))*180/pi;
%doasprime=[];
%doasprime(1,1)=ZOAV1;
%doasprime(2,1)=AOAV1;
%doasprime(1,2)=ZOAV2;
%doasprime(2,2)=AOAV2;
%[weight1,weight2,multiplier1,multiplier2] = NullSteeringBeamforming(Geometry,Pars,doasprime);
%[weight1,weight2,multiplier1,multiplier2] = LMStrial(Geometry,Pars,doasprime,chOut,waveform1,waveform2);
[weight1, weight2]=LMSBeamforming(Pars, chOut, waveform1, waveform2);
arrout1=[];
arrout2=[];
for n=1:length(chOut)
    index1=0;
    index2=0;
    for m=1:Pars.nant
        index1=index1+conj(weight1(m))*chOut(n,m);
        index2=index2+conj(weight2(m))*chOut(n,m);
    end
    arrout1=[arrout1;index1];
    arrout2=[arrout2;index2];
end
if step==1
   Scatterplot(1,chOut,ofdmDemod1,arrout1,weight1,Geometry,Pars);
   Scatterplot(2,chOut,ofdmDemod2,arrout2,weight2,Geometry,Pars);
end
[BER1,BER2]=BERcalculator(in1,in2,dataInput1,dataInput2,arrout1,arrout2,ofdmDemod1,ofdmDemod2,Pars);
BERvect1(step)=BER1;
BERvect2(step)=BER2;
end
meanBER1=mean(BERvect1);
meanBER2=mean(BERvect2);