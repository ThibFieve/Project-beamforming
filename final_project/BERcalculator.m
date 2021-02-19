function[BER1,BER2]=BERcalculator(in1,in2,dataInput1,dataInput2,arrout1,arrout2,ofdmDemod1,ofdmDemod2,Pars)
dataOutput1=ofdmDemod1(arrout1);
dataOutput2=ofdmDemod2(arrout2);
index=(Pars.fftlen-2*Pars.ngsc);%remove number of guard bands
datain1=dataInput1(:,1);%input data (ofdm mod, qam mod)
datain2=dataInput2(:,1);%input data (ofdm mod, qam mod)
dataout1=dataOutput1(:,1);%output data (ofdm demod, qam mod)
dataout2=dataOutput2(:,1);%output data (ofdm demod, qam mod)
alpha1=real(sum(datain1.*conj(dataout1)));%equalization for qam
alpha1=alpha1/(sum(dataout1.*conj(dataout1)));%equalization for qam
beta1=-imag(sum(datain1.*conj(dataout1)));%equalization for qam
beta1=beta1/(sum(dataout1.*conj(dataout1)));%equalization for qam
dataOutput1=dataOutput1*(alpha1+i*beta1);%equalized signal
alpha2=real(sum(datain2.*conj(dataout2)));
alpha2=alpha2/(sum(dataout2.*conj(dataout2)));
beta2=-imag(sum(datain2.*conj(dataout2)));
beta2=beta2/(sum(dataout2.*conj(dataout2)));
dataOutput2=dataOutput2*(alpha2+i*beta2);
output1=qamdemod(dataOutput1,Pars.M,'gray', 'OutputType', 'bit', 'UnitAveragePower', true);%qamdemod
output2=qamdemod(dataOutput2,Pars.M,'gray', 'OutputType', 'bit', 'UnitAveragePower', true);%qamdemod
out1=[];%output bits after demod
out2=[];%output bits after demod
index=(Pars.fftlen-2*Pars.ngsc)*log2(Pars.M);
for m=1:index
    for n=1:Pars.numsymbols
        out1(index*n-index+m)=output1(m,n);
        out2(index*n-index+m)=output2(m,n);
    end
end %removing bits in guard subcarriers
error1=transpose(out1)-in1;%error vector
error2=transpose(out2)-in2;
wrongbits1=sum(abs(error1(index+1:length(error1))));%number of wrong bits
wrongbits2=sum(abs(error2(index+1:length(error2))));
BER1=wrongbits1/(length(error1)-index);%BER
BER2=wrongbits2/(length(error2)-index);
end
