function params_comp_all = SF_prfPropertiesCompare(subjects)
% NP_prfPropertiesCompare - Plots Sigma vs eccentricity for the pRF fits of Natural and
% phase scrambled bar stimuli
%
% Input - subject folder names in a cell array
%
% 31/10/2018: written by Akhil Edadan (a.edadan@uu.nl)

numSub = length(subjects);

fprintf('number of subjects - %d',numSub);

for sub_idx = 1:numSub
    
    subjID = subjects{sub_idx};
    fprintf('\n Subject selected: %s \n',subjID);
    
    %% Initializing required variables
    warning('off');
    % Go to the root path where a simlink called data is created, containing
    % the data
    dirPth = SF_loadPaths(subjID);
    %
    cd(SF_rootPath);
    %
    % % set options
    opt = SF_getOpts(subjID,'MsPlot',0,'extractPrfParams',0,'plotTimeSeries',0,'getTimeSeries',0,'verbose',0,'getPredictedResponse',0);
    
    
    %% Extract pRF parameters
    
    if opt.extractPrfParams
        % get the pRF parameters for all condition
        modelData.all = SF_getModelParams_all(opt,dirPth);
        
        % Use the roi_index used here for thresholding the other conditions
        % variance explained threshold from all condition will be used to
        % threshold the values
        fprintf('(%s) extracting prf parameters from all roi and saving...',mfilename)
        modelData = SF_getModelParams(modelData,opt,dirPth);
        fprintf('\n DONE \n');
        
    else
        
        fprintf('(%s) loading previously saved prf parameters...',mfilename)
        dirPth.saveDirPrfParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
        load(fullfile(dirPth.saveDirPrfParams,'prfParams.mat'),'modelData');
        
    end
    
    %% Get time series
    if opt.plotTimeSeries
        % Get the time series
        if opt.getTimeSeries
            data = SF_getTimeSeries(dirPth,opt);
            
            % Determine the predicted fMRI response for every roi voxels
            if opt.plotTimeSeries
                if opt.getPredictedResponse
                    SF_getPredictedResponse(data,opt,modelData);
                end
                if opt.verbose
                    
                    % Plot original and predicted timeSeries: Figure 1
                    NP_makeFigure1(data,Cond_model,opt,dirPth);
                    
                end
            end
        end
    end
    
    %% Analysis of pRF model parameters
    
    % identify prf parameters that has to be compared
    [params_comp,opt] = SF_prfParametersToCompare(modelData.comp,opt,dirPth);
    
    % Supplementary figure
    if opt.verbose
        % pRF size parameter vs eccentrcity plots for individual suibjects
        SF_plotRawParameters(params_comp,opt,dirPth);
    end
    
    % Fitted line to the pRF size parameter vs eccentrcity plots for individual suibjects
    params_comp = SF_fitParameters(params_comp,opt);
    % Figure 2
    if opt.verbose
        SF_plotFit(params_comp,opt,dirPth);
    end
    
    
    % Fitted line to the pRF size parameter vs eccentrcity plots for individual suibjects
    params_comp = SF_binParameters(params_comp,opt);
    params_comp_all.bin{sub_idx} = params_comp.bin;
    
    % Figure 2
    if opt.verbose
        SF_plotBin(params_comp,opt,dirPth);
    end
    
    
    numCond = length(opt.conditions);
    numRoi = length(opt.rois);
    % Find the central value for individual suibjects
    for cond_idx = 1:numCond
        for roi_idx = 1:numRoi
            params_comp.cen(cond_idx,roi_idx) = SF_CEN(params_comp.fit.fitStats{cond_idx,roi_idx}.p,opt);
            params_comp_all.cen(cond_idx,roi_idx,sub_idx) = params_comp.cen(cond_idx,roi_idx);
            
            params_comp.auc(cond_idx,roi_idx) = SF_AUC(params_comp.bin.binVal_comp{cond_idx,roi_idx}.x,params_comp.bin.binVal_comp{cond_idx,roi_idx}.y,opt);
            params_comp_all.auc(cond_idx,roi_idx,sub_idx) = params_comp.auc(cond_idx,roi_idx);
        end
    end
    
%     Individual plots for central values and AUC
%     if opt.verbose
%         SF_plotCentral(params_comp,opt,dirPth);
%     end
    
   
end

if opt.saveData
    
    if ~exist(dirPth.saveDirStatsRes,'dir')
        mkdir(dirPth.saveDirStatsRes);
    end
    
    filename_res = 'cen_auc.mat';
    save(fullfile(dirPth.saveDirStatsRes,filename_res),'params_comp_all');
    
end




% finished =0;
% if finished
%     %% Plot figures for manuscript
%     
%     % Select ROIs
%     num_roi = length(opt.rois);
%     cur_roi = struct();
%     % Plot raw data and the fits
%     close all;
%     params_comp_all = cell(1,num_roi);
%     for roi_idx = 1:num_roi
%         cur_roi.roi_idx = roi_idx;
%         
%         
%         % Plot binned data according to eccentricity, fitted a line to the mean
%         % within the bin, bootstrapped the bins 1000 times without replacement
%         % and calculated the 97.5 % CI
%         fprintf('Binning and bootstrapping the data for roi %s \n',roi_name{1})
%         
%         % Bootstrap the data and bin the x parameter
%         [params_comp.bin.binVal_comp_1,params_comp.bin.binValUpper_comp_1,params_comp.bin.binValLower_comp_1,params_comp.bin.binXVal_comp_1] = NP_bin_param(params_comp.raw.x_comp_1,params_comp.raw.y_comp_1,params_comp.raw.varexp_comp_1,params_comp.fit.xfit,opt);
%         [params_comp.bin.binVal_comp_2,params_comp.bin.binValUpper_comp_2,params_comp.bin.binValLower_comp_2,params_comp.bin.binXVal_comp_2] = NP_bin_param(params_comp.raw.x_comp_2,params_comp.raw.y_comp_2,params_comp.raw.varexp_comp_2,params_comp.fit.xfit,opt);
%         % Find the best fitting line to the mean values within the bins. Bootstrap across
%         % bins and find the 95 % CI (not weigted with the ve)
%         [params_comp.bin.binValFit_comp_1,params_comp.bin.fitStats_1] = NP_fit(params_comp.bin.binVal_comp_1.x,params_comp.bin.binVal_comp_1.y,[],params_comp.bin.binVal_comp_1.x);
%         [params_comp.bin.binValFit_comp_2,params_comp.bin.fitStats_2] = NP_fit(params_comp.bin.binVal_comp_2.x,params_comp.bin.binVal_comp_2.y,[],params_comp.bin.binVal_comp_2.x);
%         
%         % SUPPLEMENTARY FIGURE 1 ****
%         if opt.MsPlot
%             if opt.verbose
%                 % Plot binned fit: Figure 4
%                 NP_makeFigure4(params_comp,cur_roi,opt,dirPth);
%             end
%         end
%         
%         % Calculate difference in area under the curve between the two conditions
%         params_comp.auc.in.x = [params_comp.bin.binVal_comp_1.x', params_comp.bin.binVal_comp_2.x'];
%         params_comp.auc.in.y = [params_comp.bin.binVal_comp_1.y', params_comp.bin.binVal_comp_2.y'];
%         
%         params_comp.auc.aucDiff = NP_AUC(params_comp.auc.in.x,params_comp.auc.in.y);
%         [params_comp.auc.bootstrapAucDiff,params_comp.auc.aucUpper,params_comp.auc.aucLower] = NP_AUC_bootstrap(params_comp.auc.in.x,params_comp.auc.in.y);
%         
%         % Calculate central values and difference in central values
%         % stimulus range is 5 degrees radius. central value is calculated
%         % at 2.5 degrees: Y2.5 = m*2.5 + c
%         [params_comp.cen.cenVal_1,params_comp.cen.cenVal_2,params_comp.cen.cenDiff,params_comp.cen.cenDiffRel] = NP_CEN(params_comp);
%         
%         
%         % Save the parameters from all ROIs
%         params_comp_all{roi_idx}=params_comp;
%         
%     end
%     
%     if opt.detailedPlot
%         if opt.verbose
%             % figure - average of difference in prf size
%             NP_makeFigure2A(params_comp_all,cur_roi,opt,dirPth);
%         end
%     end
%     
%     % SUPPLEMENTARY FIGURE 2 ****
%     if opt.MsPlot
%         % Plot central values: Figure 5A
%         NP_makeFigure5A(params_comp_all,opt,dirPth);
%     end
%     
%     if opt.detailedPlot
%         if opt.verbose
%             % Plot auc: Figure 5
%             NP_makeFigure5(params_comp_all,opt,dirPth);
%         end
%     end
%     
%     params_comp_all_sub{sub_idx} = params_comp_all;
%     
%     if opt.saveData
%         
%         dirPth.saveDirCompParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
%         if ~exist(dirPth.saveDirCompParams,'dir')
%             mkdir(dirPth.saveDirCompParams);
%         end
%         
%         filename_res = 'compParams.mat';
%         save(fullfile(dirPth.saveDirCompParams,filename_res),'params_comp_all');
%         
%     end
%     
% end
% 
% params_comp_all_sub{sub_idx+1} = subjects;
% 
% opt_all = NP_getOpts_all;
% dirPth_all = NP_loadPaths_all;
% 
% if opt_all.aveSub
%     % Plot average auc across all subjects: Figure 6
%     NP_makeFigure6(params_comp_all_sub,opt_all,dirPth_all)
%     
%     % MAIN FIGURE 3 ********
%     % SUPPLEMENTARY FIGURE 3 ****
%     % Plot average central value across all subjects: Figure 7
%     NP_makeFigure7(params_comp_all_sub,opt_all,dirPth_all)
%     
%     if opt.saveData
%         
%         dirPth_all.saveDirCompParamsAllSub = fullfile(dirPth_all.saveDirRes,strcat(opt_all.modelType,'_',opt_all.plotType));
%         if ~exist(dirPth_all.saveDirCompParamsAllSub,'dir')
%             mkdir(dirPth_all.saveDirCompParamsAllSub);
%         end
%         
%         filename_res = 'compParamsAllSub.mat';
%         save(fullfile(dirPth_all.saveDirCompParamsAllSub,filename_res),'params_comp_all_sub');
%         
%     end
% end
% 
% fprintf('\n (%s)Done! \n',mfilename);
% 
% end


end







