function SF_getPredictedResponse(data,opt,modelData)
numCond = length(opt.conditions);
numRoi = length(opt.rois);

for cond_idx = 1:numCond
    cur_cond = opt.conditions{cond_idx};
    for roi_idx = 1:numRoi
        cur_roi     = opt.rois{roi_idx};
        roiThrIdx   = ROI_params{roi_idx,'roi_index'}{1};
        data.timeSeries_rois_thr{cond_idx,roi_idx}.tSeries = data.timeSeries_rois{cond_idx,roi_idx}.tSeries(:,roiThrIdx);
        
        stim    = data.timeSeries_rois{1}.params.stim;
        model   = Cond_model{cond_idx,cur_roi}{1};
        pred    = NP_getPredictedResponse(stim,model); % prediction = (stim*pRFModel)xBeta
        data.predictions_rois{cond_idx,roi_idx} = pred;
    end
end

end
