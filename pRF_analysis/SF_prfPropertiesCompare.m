function params_comp_all = SF_prfPropertiesCompare(subjects,bb)
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
    dirPth = SF_loadPaths(subjID,bb);
    %
    cd(SF_rootPath);
    %
    % % set options
    if ~bb
        conditions = {'sf03';'sf06';'sf12'};
    else
        conditions = {'pRF_scram'};
    end
    
    opt = SF_getOpts(subjID,'MsPlot',0,'verbose',0,'extractPrfParams',0,'plotTimeSeries',0,'getTimeSeries',0,'getPredictedResponse',0,'conditions',conditions);
    
    
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
                    data = SF_getPredictedResponse(data,opt,modelData.comp);
                end
                if opt.verbose
                    
                    % Plot original and predicted timeSeries: Figure 1
                    NP_makeFigure1(data,modelData,opt,dirPth);
                    
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



end







