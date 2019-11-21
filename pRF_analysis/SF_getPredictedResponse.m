function data = SF_getPredictedResponse(data,opt,modelData)
% SF_getPredictedResponse - Extract raw time series from the model file and
% generate the plot for different conditions
%
% input - dirPth : Path to the directory containing model files
%       - opt    : different options
%
% 20/11/2019: written by Akhil Edadan (a.edadan@uu.nl)

% Define the different conditions to be compared
conditions = opt.conditions;
numCond    = length(conditions);

rois   = opt.rois;
numRoi = length(rois);

data.predictions_rois    = cell(numCond,numRoi);
data.timeSeries_rois_thr = cell(numCond,numRoi);

for cond_idx = 1:numCond
    curCond  = conditions{cond_idx};
    
    fprintf('%s...',curCond);
  
    for roi_idx = 1:numRoi
       
        roiThrIdx = modelData.roi_index{cond_idx,roi_idx};
        
        % save the timeseries and coordinates thresholded using
        % varaince explained and eccentricity
        data.timeSeries_rois_thr{cond_idx,roi_idx}.tSeries                 = data.timeSeries_rois{cond_idx,roi_idx}.tSeries(:,roiThrIdx);
        data.timeSeries_rois_thr{cond_idx,roi_idx}.coords                  = data.timeSeries_rois{cond_idx,roi_idx}.coords(:,roiThrIdx);
        data.timeSeries_rois_thr{cond_idx,roi_idx}.params.roi.coords       = data.timeSeries_rois{cond_idx,roi_idx}.params.roi.coords(:,roiThrIdx);
        data.timeSeries_rois_thr{cond_idx,roi_idx}.params.roi.coordsIndex  = data.timeSeries_rois{cond_idx,roi_idx}.params.roi.coordsIndex(:,roiThrIdx);
        
        params    = data.timeSeries_rois{cond_idx,roi_idx}.params;
        model     = modelData.modelInfo{cond_idx,roi_idx};
        pred      = SF_computePredictedResponse(model,data.timeSeries_rois{cond_idx,roi_idx},params); % prediction = (stim*pRFModel)xBeta
        
        data.predictions_rois{cond_idx,roi_idx} = pred;
        data.predictions_rois_thr{cond_idx,roi_idx} = data.predictions_rois{cond_idx,roi_idx}(:,roiThrIdx);
       
    end
end

end
