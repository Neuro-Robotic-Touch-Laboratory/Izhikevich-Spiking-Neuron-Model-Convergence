
function t = calculate_time_convergence(distance,threshold,N_stop,diff_v)

element_convergence = distance(N_stop:end)<threshold;
chiappetta = bwconncomp(element_convergence);
if numel(chiappetta.PixelIdxList) ~= 0
    element_convergence = chiappetta.PixelIdxList{end};
    element_convergence = N_stop + element_convergence(1) -1 ;
    t = diff_v.Time(element_convergence);
else
    t = NaN;
end

end