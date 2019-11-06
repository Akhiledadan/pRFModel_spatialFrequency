function params_comp = SF_binParameters(params_comp,opt)

% Plot binned data according to eccentricity, fitted a line to the mean
% within the bin, bootstrapped the bins 1000 times without replacement
% and calculated the 97.5 % CI
fprintf('\n (%s) Binning and bootstrapping the data for roi \n',mfilename)

numCond = length(opt.conditions);
numRoi  = length(opt.rois);

params_comp.fit.x_fit = linspace(opt.eccThr(1),opt.eccThr(2),20)';

for cond_idx = 1:numCond
    for roi_idx = 1:numRoi
        
        [params_comp.bin.binVal_comp{cond_idx,roi_idx},params_comp.bin.binValUpper_comp{cond_idx,roi_idx},params_comp.bin.binValLower_comp{cond_idx,roi_idx},params_comp.bin.binXVal_comp{cond_idx,roi_idx}] = NP_bin_param(params_comp.x_comp{cond_idx,roi_idx},params_comp.y_comp{cond_idx,roi_idx},params_comp.ve_comp{cond_idx,roi_idx},params_comp.fit.x_fit,opt);
        
    end
end

fprintf('\n (%s) Done \n',mfilename);

end