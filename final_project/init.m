clear all,clc,close all;

% This is for fast run of the code [%%%]
%chan=0;
%load Rapidchannel.mat

% Define system parameters
Pars.fc     = 1e9; % Carrier frequency
Pars.c      = physconst('LightSpeed');%light speed
Pars.lambda = Pars.c/Pars.fc;%wavelength
Pars.SNR = -8;%SNR (dB)
Pars.M= 4;%modulation order
Pars.fftlen=256;%number of subcarriers
Pars.cplen=72;%length of cyclic prefix
Pars.ngsc=8;%number of guard subcarriers
Pars.numsymbols=30;%number of OFDM symbols
%Pars.pilotidx1=[Pars.fftlen*0.75];
%Pars.pilotidx2=[Pars.fftlen*0.25];
Pars.nant=64;%number of BS antenaas
Pars.numpositions=10;%number of positions of the vehicles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define geometry of the problem (xyz)
Geometry.BSPos      =[0,0,25];
Geometry.V1PosStart =[70,-100,1.5]; % Start posizione of vehicle 1
Geometry.V1PosEnd   =[70,100,1.5]; % Start position of vehicle 1
Geometry.V2PosStart =[200,-50,1.5]; % Start posizione of vehicle 2
Geometry.V2PosEnd   =[10,-50,1.5]; % Start position of vehicle 2
Geometry.I1Pos      =[10,-210,1.5]; % Position of interferer 1
Geometry.I2Pos      =[-150,100,1.5]; % Position of interferer 2
% Calculate distances
Geometry.T1 = sqrt(sum((Geometry.V1PosEnd(1,1:2)-Geometry.V1PosStart(1,1:2)).^2));
Geometry.T2 = sqrt(sum((Geometry.V2PosEnd(1,1:2)-Geometry.V2PosStart(1,1:2)).^2));    
Geometry.DistV1Start = sqrt(sum((Geometry.V1PosStart(1,1:2)-Geometry.BSPos(1,1:2)).^2));
Geometry.DistV2Start = sqrt(sum((Geometry.V2PosStart(1,1:2)-Geometry.BSPos(1,1:2)).^2));
% Calculate DoA for V1 at start
Geometry.AOAV1Start = atan2(Geometry.BSPos(1,2)-Geometry.V1PosStart(1,2),...
   Geometry.BSPos(1,1)-Geometry.V1PosStart(1,1))*180/pi;
Geometry.ZOAV1Start=atan2(Geometry.DistV1Start,...
   Geometry.BSPos(1,3)-Geometry.V1PosStart(1,3))*180/pi;
Geometry.DOAV1S=[Geometry.AOAV1Start Geometry.ZOAV1Start]; 
% Calculate DoA for V2 at start
Geometry.AOAV2Start = atan2(Geometry.BSPos(1,2)-Geometry.V2PosStart(1,2),...
   Geometry.BSPos(1,1)-Geometry.V2PosStart(1,1))*180/pi;
Geometry.ZOAV2Start=atan2(Geometry.DistV2Start,...
   Geometry.BSPos(1,3)-Geometry.V2PosStart(1,3))*180/pi;
Geometry.DOAV2S=[Geometry.AOAV2Start Geometry.ZOAV2Start]; 
% Define Base Station Array
Geometry.BSarray=phased.URA('Size',[sqrt(Pars.nant) sqrt(Pars.nant)],...
   'ElementSpacing',[Pars.lambda/2 Pars.lambda/2],...
   'ArrayNormal','z');
Geometry.BSAntennaPos = getElementPosition(Geometry.BSarray);


%Two Rays sinusoid ( To do cyle with more positions and check result)<-- id
%needed, otherwise no
% [RxPow,PrTheory,PrApprox] = TwoRaySinusoid(Geometry,Pars);
%ofdm3;
%quadriga multipath
%[q_layout,Geometry,chan,chOut,DoAEstimation]=CreateScenarioAndVisualize_quadriga2(Geometry, Pars,chan); % This is for fast run of the code, remove chan as input argument[%%%]
%[q_layout,Geometry,chan,chOut,DoAEstimation]=TrialCreateScenarioAndVisualize_quadriga(Geometry, Pars,chan); % This is for fast run of the code, remove chan as input argument[%%%]

%Calculation on the waveform
% receivedW = collectPlaneWave(Geometry.BSarray,[waveform1,waveform2],...
%     [Geometry.DOAV1S' Geometry.DOAV2S],Pars.fc);

% add AWGN
% chOut=awgn(receivedW,Pars.SNR,'measured');
