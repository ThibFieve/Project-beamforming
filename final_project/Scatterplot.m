function[]=Scatterplot(number,chOut,ofdmDemod,arrout,weight,Geometry,Pars)
% Without beamformer
no_b_out = ofdmDemod(chOut(:,1));
figure,
%Plotting a scattergraph
no_b_x=real(no_b_out);
no_b_x=reshape(no_b_x,[size(no_b_x,1)*size(no_b_x,2),1]);
no_b_y=imag(no_b_out);
no_b_y=reshape(no_b_y,[size(no_b_y,1)*size(no_b_y,2),1]);
scatter(no_b_x,no_b_y),
title(['connstellation ', number ,' without beamformer']);
grid on;
% With beamformer
yes_b_out = ofdmDemod(arrout);
figure,
%Plotting a scattergraph
yes_b_x=real(yes_b_out);
yes_b_x=reshape(yes_b_x,[size(yes_b_x,1)*size(yes_b_x,2),1]);
yes_b_y=imag(yes_b_out);
yes_b_y=reshape(yes_b_y,[size(yes_b_y,1)*size(yes_b_y,2),1]);
scatter(yes_b_x,yes_b_y),
title(['connstellation ', number ,' with beamformer']);
grid on;
% check output
figure,
plot(abs(fft(chOut(:,1))));
title(['power spectrum', number]);
figure,
pattern(Geometry.BSarray,Pars.fc,[-180:180],0,...
    'CoordinateSystem','rectangular',...
    'Type','powerdb','PropagationSpeed',physconst('LightSpeed'),...
    'Weights',weight);
title(['power' number]);
end