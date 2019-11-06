function modelData = SF_getModelParams_all(opt,dirPth)
% SF_getModelParams - function to extract pRF model parameters into different ROIs
%
% input  - dirPth     : directory where pRF model is saved
% output - Cond_model : table containing ROI
%
% need - coords, prfparameter

% Define the different conditions to be compared
conditions = {'all'};
numCond = length(conditions);

rois = opt.rois;
numRoi = length(rois);

modelData.modelInfo      = cell(numCond,numRoi);
modelData.roi_index      = cell(numCond,numRoi);
modelData.modelInfo_thr  = cell(numCond,numRoi);


for cond_idx = 1:numCond
    
    curCond = conditions{cond_idx};

        fprintf('%s...',curCond);
        
        dirPth.modelPathInd = fullfile(dirPth.modelPath,conditions{cond_idx});
        dirPth.coordsPath = fullfile(dirPth.sessionPath,'Gray');
        dirPth.meanPath = fullfile(dirPth.sessionPath,'Gray',conditions{cond_idx});
        
        
        model_fname =  dir(fullfile(dirPth.modelPathInd,'*-fFit-fFit-fFit.mat'));
        
        if length(model_fname)>1
            warning('more than one model fit, selecting the latest one. Select a different model otherwise')
            % Update this with a code to determine the date of model and
            % selecting the latest
            tmp = model_fname;
            model_fname = [];
            model_fname = getlatestmodel(tmp);
            
        end
        

        % Load coordinate file
        coordsFile = fullfile(dirPth.coordsPath,'coords.mat');
        
        % Mean map
        meanMapFile = fullfile(dirPth.meanPath,'meanMap.mat');
        
        
        modelData.modelFile{cond_idx} = fullfile(model_fname.folder,model_fname.name);
        modelData.coordsFile{cond_idx} = coordsFile;
        modelData.meanMapFile{cond_idx} = meanMapFile;
        
        % Load coords file for a subject
        load(coordsFile);
        Mmap = load(meanMapFile);
        % Load the model
        load(fullfile(model_fname.folder,model_fname.name));
        

        for roi_idx = 1:numRoi
            
            curRoiPth = fullfile(dirPth.roiPath,strcat(rois{roi_idx},'.mat'));
            roi_fname{cond_idx,roi_idx} = curRoiPth;
            
            %Load the current roi
            load(curRoiPth);
            
            % find the indices of the voxels from the ROI intersecting with all the voxels
            [~, indices_mean] = intersect(coords', ROI.coords', 'rows' );
            mean_map = Mmap.map{1}(1,indices_mean);
            
            % Current model parameters- contains x,y, sigma, from current
            % condition and current subject and for the current ROI
            model_data = GetInfoModel(modelData.modelFile{cond_idx},coordsFile,curRoiPth);
            model_data{1}.beta = model_data{1}.beta';
            model_data{1}.sigmaFWHM = model_data{1}.sigma .* 2.355; % FWHM = sigma .* 2.355
            
            
            if strcmpi(opt.modelType,'DoGs')
                % Difference of gaussians parameters
                rm = load(modelData.modelFile{cond_idx});
                [fwhmax,surroundSize,fwhmin_first, fwhmin_second, diffwhmin,~] = rmGetDoGFWHM(rm.model{1},{indices_mean});
                stimRadius = 5;
                [suppressionIndex, ~, ~, ~, ~] = rmGetDoGSuppressionIndex(rm.model{1},'roi',indices_mean,'sts',stimRadius);
                model_data{1}.DoGs_fwhmax = fwhmax;
                model_data{1}.DoGs_surroundSize = surroundSize;
                model_data{1}.DoGs_fwhmin_first = fwhmin_first;
                model_data{1}.DoGs_fwhmin_second = fwhmin_second;
                model_data{1}.DoGs_diffwhmin = diffwhmin;
                model_data{1}.DoGs_suppressionIndex = suppressionIndex;
%                 model_data{1}.DoGs_beta1 = beta1;
%                 model_data{1}.DoGs_beta2 = beta2;
            end
            
            % For every condition and roi, save the index_thr and add them to
            % the Cond_model table so that they can be loaded later
            index_thr_tmp = model_data{1}.varexp > opt.varExpThr & model_data{1}.ecc < opt.eccThr(2) & model_data{1}.ecc > opt.eccThr(1) & mean_map > opt.meanMapThr;
            
            % Determine the thresholded indices for each of the ROIs
            %roi_index{roi_idx,1} = index_thr_tmp{1,1} & index_thr_tmp{2,1};
            modelData.roi_index{cond_idx,roi_idx} = index_thr_tmp;
            modelData.roiCoords{cond_idx,roi_idx} = ROI.coords;
            
            % Apply these thresholds on the pRF parameters for both the conditions
            model_data_thr = SF_params_thr(model_data{1},modelData.roi_index{cond_idx,roi_idx},opt);
 
            modelData.modelInfo{cond_idx,roi_idx}     = model_data{1};
            modelData.modelInfo_thr{cond_idx,roi_idx} = model_data_thr;
            modelData.roiCoords_thr{cond_idx,roi_idx} = ROI.coords(:,index_thr_tmp);
        end
     
end


%%
if opt.saveData
    
   dirPth.saveDirPrfParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
   if ~exist('saveDir','dir')
       mkdir(dirPth.saveDirPrfParams);
   end 
           
   filename_res = 'prfParams_all.mat';
   save(fullfile(dirPth.saveDirPrfParams,filename_res),'modelData');
    
end

end