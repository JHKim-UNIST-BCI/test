function maxind = decoder(T,v,Stau,cha_vol)

figure;hold on;
plot(T,v,'k') % plot voltage v

maxind = []; % initialization of peak index (size = number of peak)
tau =[]; % initialization of relaxation time
signind = []; 

for st = 4:length(v)
    
    if (v(st-1) > 5) & (((v(st-1)-v(st-2)) > 1)|(v(st-1)-v(st-3))>0.2) & (sign(v(st-2)-v(st-1)) ~= sign(v(st-1)-v(st))) & (v(st-2)-v(st-1)<0) & (v(st-1) ~= v(st))
        tau2 = 0.002/log(v(st-1)/v(st)); % calculate relaxation time
        if tau2 > 1
           tau2 =  0.002/log(v(st)/v(st+1));
        end
        maxind = [maxind; st-1]; % stack recent index to peak index variable 
        tau = [tau; tau2]; % stack recent relaxation time to relaxation time vairalbe
    end
    if sign(v(st-2)-v(st-1)) ~= sign(v(st-1)-v(st)) 
       signind = [signind; st-1]; % To find the peak voltage, find all time points where the sign changes
    end
    
end

ind = dsearchn(Stau,tau); % Find the closest value to the index tau value and distinguish which pick the signal is from.

% find voltage level
for i = 1:length(maxind)
    tmp = find(signind==maxind(i)); % peak index
    peak_voltage(i)=v(signind(tmp))-v(signind(tmp-1)); % index which sign is changed 
    plot(T(signind(tmp)),v(signind(tmp)),'r*','MarkerSize',5)
    plot(T((signind(tmp-1))),v((signind(tmp-1))),'g*','MarkerSize',5)
end

disp(peak_voltage) 
real_tau = dsearchn(Stau,tau);
real_tau(peak_voltage < cha_vol) = 1;
disp([ind tau real_tau])

end