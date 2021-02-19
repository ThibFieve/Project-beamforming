distance=[];
for n=1:Pars.numpositions
    position1=selected_chan1.tx_position(:,positionvect1(n));
    position2=selected_chan2.tx_position(:,positionvect2(n));
    distance(n)=norm(position1-position2);
end
figure();
plot([1:Pars.numpositions],BERvect1,'blue');
hold on;
plot([1:Pars.numpositions],BERvect2,'red');
%surf(position1,position2,BERvect1);
figure();
plot(distance,BERvect1,'green');
figure();
plot(distance,BERvect2);

    