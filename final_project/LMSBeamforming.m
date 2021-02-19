function[w1,w2]=LMSBeamforming(Pars, chOut, waveform1, waveform2)
format long;
w1=ones(1,Pars.nant);
w2=ones(1,Pars.nant);
signal=chOut(Pars.cplen+1:Pars.cplen+Pars.fftlen,:);%received signal(1st symbol time)
d1=(waveform1(Pars.cplen+1:Pars.cplen+Pars.fftlen));%pilot1(1st symbol time)
d2=(waveform2(Pars.cplen+1:Pars.cplen+Pars.fftlen));%pilot2(1st symbo time)
mu=1;
for k=1:100
for m=1:Pars.fftlen
    y1=0;%estimated signal
    y2=0;%estimated signal
    for n=1:Pars.nant
        y1=y1+signal(m,n)*conj(w1(n));
        y2=y2+signal(m,n)*conj(w2(n));
    end
    e1=y1-d1(m);%error
    e2=y2-d2(m);%error
    w1=w1-mu*signal(m,:)*conj(e1)/(norm(signal(m,:))^2);%weight
    w2=w2-mu*signal(m,:)*conj(e2)/(norm(signal(m,:))^2);%weight
end
mu=mu*0.95;
end
w1=transpose(w1);
w2=transpose(w2);
end
    
    



