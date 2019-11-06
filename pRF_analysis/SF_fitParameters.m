function params_comp = SF_fitParameters(params_comp,opt)

% Do a linear regression of the two parameters weighted with the variance explained
fprintf('\n (%s) Calculating slope and intercept for the best fitting line for the conditions for roi \n',mfilename);

numCond = length(opt.conditions);
numRoi  = length(opt.rois);

params_comp.fit.x_fit = linspace(opt.eccThr(1),opt.eccThr(2),20)';

for cond_idx = 1:numCond
    for roi_idx = 1:numRoi
        
        [params_comp.fit.yfit_comp{cond_idx,roi_idx},params_comp.fit.fitStats{cond_idx,roi_idx}] = NP_fit(params_comp.x_comp{cond_idx,roi_idx},params_comp.y_comp{cond_idx,roi_idx},params_comp.ve_comp{cond_idx,roi_idx},params_comp.fit.x_fit);
        
    end
end

fprintf('\n (%s) Done \n',mfilename);

end