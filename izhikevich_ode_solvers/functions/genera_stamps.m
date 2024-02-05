function stamps = genera_stamps(potenziale,recovery,c)
stamps = [];
for i=2:numel(potenziale.Data)
    if((potenziale.Data(i)== c) && (recovery.Data(i)-recovery.Data(i-1) >= 1))   
        stamps = [stamps recovery.Time(i-1)];
    end
end

end