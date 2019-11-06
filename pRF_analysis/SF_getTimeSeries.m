function data = SF_getTimeSeries(dirPth,opt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes long time to load - preload and save
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(dirPth.sessionPath);

hView = initHiddenGray;

numCond = length(opt.conditions);
numRoi = length(opt.rois);

if opt.getTimeSeries
    data.timeSeries_rois = cell(numCond,numRoi);
    for cond_idx = 1:numCond
        cur_cond = opt.conditions{cond_idx};
        hView = viewSet(hView,'curdt',cur_cond);
        dirPth.model_path_ind = fullfile(dirPth.modelPth,cur_cond);
        model_fname =  dir(fullfile(dirPth.model_path_ind,'*_refined_*-fFit.mat'));
        hView = rmSelect(hView,1,fullfile(model_fname.folder,model_fname.name));
        
        params = viewGet(hView, 'rmParams');
        
        for roi_idx =1:numRoi
            cur_roi = opt.rois{roi_idx};
            load(fullfile(dirPth.roiPth,[cur_roi '.mat']));
            
            ts_fileName = sprintf('TS_%s_%s',cur_cond,cur_roi);
            ts_fullFileName = fullfile(dirPth.model_path_ind,ts_fileName);
            
            % check if there are time series data already saved. If yes, load them
            % instead of reextracting.
            
            if ~exist([ts_fullFileName '.mat'],'file')
                % get time series and roi-coords
                [TS.tSeries, TS.coords, TS.params] = rmLoadTSeries(hView, params, ROI, 1);
                
                % detrend
                % get/make trends
                trends  = rmMakeTrends(params);
                
                % recompute
                b = pinv(trends)*TS.tSeries;
                TS.tSeries = TS.tSeries - trends*b;
                
                data.timeSeries_rois{cond_idx,roi_idx} = TS;
                
                save(ts_fullFileName,'TS');
                fprintf('saving roi: %s for condition: %s',cur_cond,cur_roi);
                
            else
                fprintf('loading roi: %s for condition: %s \n',cur_roi,cur_cond);
                ts_fileName = sprintf('TS_%s_%s',cur_cond,cur_roi);
                ts_fullFileName = fullfile(dirPth.model_path_ind,ts_fileName);
                load(ts_fullFileName);
                data.timeSeries_rois{cond_idx,roi_idx} = TS;
                
            end
            
        end
    end

else
    numCond = length(opt.conditions);
    numRoi  = length(opt.rois);
    for cond_idx = 1:numCond
        cur_cond = opt.conditions{cond_idx};
        dirPth.model_path_ind = fullfile(dirPth.modelPth,cur_cond);
        for roi_idx = 1:numRoi
            cur_roi = opt.rois{roi_idx};
            ts_fileName = sprintf('TS_%s_%s',cur_cond,cur_roi);
            ts_fullFileName = fullfile(dirPth.model_path_ind,[ts_fileName '.mat']);
            load(ts_fullFileName);
            data.timeSeries_rois{cond_idx,roi_idx} = TS;
        end
    end
    
end
end