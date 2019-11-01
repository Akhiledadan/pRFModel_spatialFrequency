function SF_prfPropertiesComparison_3cond(subjID)

% NP_Sigma_ecc - Plots Sigma vs eccentricity for the pRF fits of different spatial frequencies
%
% Input - subjID : Name of the subject
%       -
% 12/08/2019: [A.E. & D.V.] wrote it


%%
% Go to the root path where a simlink called data is created, containing
% the data
dirPth = loadPaths(subjID);
% 
cd(SF_rootPath);
% 
% % set options
opt = getOpts;

%% Initializing required variables / paths

% Plot params
MarkerSize = opt.markerSize;

% Select the ROIs
ROI_choice_all = opt.rois;

% pRF parameters to be compared
plot_type = opt.plotType;

% Define the different conditions to be compared
conditions = opt.conditions;
num_cond = length(conditions);

% Define the location of the files
dirPth.orig_path = dirPth.sessionPth;
dirPth.roi_path = dirPth.roiPath;
dirPth.model_path = dirPth.modelPath;
dirPth.coords_path = dirPth.coordsPath;

% Make the directory to save results
if opt.saveFig == 1 || opt.saveData  == 1
    cur_time = datestr(now);
    cur_time(cur_time == ' ' | cur_time == ':' | cur_time == '-') = '_';
    save_dir = fullfile(main_dir, ['/Results/Results' '_' cur_time '_' plot_type]);
end

%%
% Load types of model to compare
model_file = cell(num_cond,1);
for cond_idx = 1:length(conditions)
    dirPth.model_path_ind = strcat(dirPth.model_path,conditions{cond_idx});
    model_fname =  dir(fullfile(dirPth.model_path_ind,'*refined_-fFit.mat'));
    
    if length(model_fname)>1
        warning('more than one model fit, selecting the latest one. Select a different model otherwise')
        % Update this with a code to determine the date of model and
        % selecting the latest
        tmp = model_fname;
        model_fname = [];
        model_fname = getlatestmodel(tmp);
        
    end
    
    model_file{cond_idx,1} = fullfile(dirPth.model_path_ind,model_fname.name);
    
end

% Create a table with different conditions and their corresponding model
% files
Cond_model = table(conditions,model_file);

% Select ROIs
num_roi = length(ROI_choice_all);
roi_fname = cell(num_roi,1);
for roi_idx = 1:num_roi
    roi_fname{roi_idx,1} = fullfile(dirPth.roi_path,strcat(ROI_choice_all{roi_idx},'.mat'));
end

% Table with different ROIs and their corresponding file dirPth
ROI_params = table(ROI_choice_all,roi_fname);

%% calculating pRF parameters to compare

% % Parameters of the all condition
% dirPth.all_model_path = strcat(dirPth.orig_path,'/Gray/all/');
% all_model = load(dir(fullfile(dirPth.all_model_path,'*-fFit-fFit-fFit.mat')));

% Load coordinate file
coordsFile = fullfile(dirPth.coords_path,'coords.mat');
load(coordsFile);

% Mean map
meanFile = fullfile(dirPth.model_path_ind,'meanMap.mat');
Mmap = load(meanFile);

% Determine the voxels for different ROIs and the corresponding prf
% parameters
for roi_idx = 1:num_roi
    %Load the current roi
    load(ROI_params.roi_fname{roi_idx});
    
    % find the indices of the voxels from the ROI intersecting with all the voxels
    [~, indices_mean] = intersect(coords', ROI.coords', 'rows' );
    mean_map = Mmap.map{1}(1,indices_mean);
    
    % preallocate variables
    model_data = cell(num_cond,1);
    index_thr_tmp = cell(num_cond,1);
    for cond_idx = 1:num_cond
        
        % Current model parameters- contains x,y, sigma,
        model_data(cond_idx,1) = GetInfoModel(Cond_model.model_file{cond_idx},coordsFile,ROI_params.roi_fname{roi_idx});
        
        rm = load(Cond_model.model_file{cond_idx});
        if strcmp(rm.model{1}.description,'Difference 2D pRF fit (x,y,sigma,sigma2, center=positive)')
            [fwhmax,surroundSize,fwhmin_first, fwhmin_second, diffwhmin] = rmGetDoGFWHM(rm.model{1},[]);
            model_data{cond_idx,1}.DoGs_fwhmax = fwhmax;
            model_data{cond_idx,1}.DoGs_surroundSize = surroundSize;
            model_data{cond_idx,1}.DoGs_fwhmin_first = fwhmin_first;
            model_data{cond_idx,1}.DoGs_fwhmin_second = fwhmin_second;
            model_data{cond_idx,1}.DoGs_diffwhmin = diffwhmin;
        end
        % For every condition and roi, save the index_thr and add them to
        % the Cond_model table so that they can be loaded later
        index_thr_tmp{cond_idx,1} = model_data{cond_idx}.varexp > opt.varExpThr & model_data{cond_idx}.ecc < opt.eccThr(2) & model_data{cond_idx}.ecc > opt.eccThr(1) & mean_map > opt.meanMapThr;
        
    end
    
    % Determine the thresholded indices for each of the ROIs
    roi_index{roi_idx,1} = index_thr_tmp{1,1} & index_thr_tmp{2,1} & index_thr_tmp{3,1} & index_thr_tmp{4,1};
    
    % Apply these thresholds on the pRF parameters for both the conditions
    model_data_thr = cell(num_cond,1);
    for cond_idx = 1:num_cond
        model_data_thr{cond_idx,1} = NP_params_thr(model_data{cond_idx},roi_index{roi_idx,1});
    end
    % Store the thresholded pRF values in a table
    add_t_1 = table(model_data_thr,'VariableNames',ROI_params.ROI_choice_all(roi_idx));
    Cond_model = [Cond_model add_t_1];
    
end
% Update the ROI_params with the thresholded index values
add_t_1_roi = table(roi_index);
ROI_params = [ROI_params add_t_1_roi];

%%

% Ideally this should be able to take in any number of conditions and
% compare them - Write it in such a way that it's scalable
%% Plots
% Plot raw data and the fits 
param_comp_diff_data_cen_allroi = nan(num_roi,1);
param_comp_diff_data_cen_allroi_up = nan(num_roi,1);
param_comp_diff_data_cen_allroi_lo = nan(num_roi,1);
param_comp_diff_data_cen_allroi_bin = nan(num_roi,1);

param_comp_diff_data_auc_allroi = nan(num_roi,1);
for roi_idx = 1:num_roi
    roi_comp = ROI_params.ROI_choice_all{roi_idx};
    data_comp_1 = Cond_model{1,1}{1};
    data_comp_2 = Cond_model{2,1}{1};
    data_comp_3 = Cond_model{3,1}{1};
   
    
    % Choose the pRF parameters to compare
    switch plot_type
        
        case 'Ecc_Sig'
            yAxis = 'Sigma';            
            
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.ecc;% sf03
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.ecc;% sf06
            x_param_comp_3 = Cond_model{3,roi_comp}{1}.ecc;% sf12
            
           
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
            y_param_comp_3 = Cond_model{3,roi_comp}{1}.sigma;
            
            z_param_comp_1 = Cond_model{1,roi_comp}{1}.varexp;
            z_param_comp_2 = Cond_model{2,roi_comp}{1}.varexp;
            z_param_comp_3 = Cond_model{3,roi_comp}{1}.varexp;
            
            
            
            % Axis limits for plotting
            xaxislim = [0 5];
            yaxislim = [0 2];
            
            % x range values for fitting
            xfit_range = opt.eccThr;
            
            
        case 'Ecc_SurSize_DoGs'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.ecc;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.ecc;
            x_param_comp_3 = Cond_model{3,roi_comp}{1}.ecc;
            
                    
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.DoGs_surroundSize;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.DoGs_surroundSize;
            y_param_comp_3 = Cond_model{3,roi_comp}{1}.DoGs_surroundSize;
            
                 
            % Axis limits for plotting
            xaxislim = [0 5];
            yaxislim = [0 5];
            
            % x range values for fitting
            xfit_range = opt.eccThr(2);
            
        case 'Pol_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.pol;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.pol;
            x_param_comp_3 = Cond_model{3,roi_comp}{1}.pol;
            
                      
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
            y_param_comp_3 = Cond_model{3,roi_comp}{1}.sigma;
            
                        
            % Axis limits for plotting
            xaxislim = [0 2*pi];
            yaxislim = [0 5];
            
            % x range values for fitting
            Pol_Thr_low = 0;
            Pol_Thr = 2*pi;
            xfit_range = [Pol_Thr_low Pol_Thr];
            
        case 'X_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.x;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.x;
            x_param_comp_3 = Cond_model{3,roi_comp}{1}.x;
            
            
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
            y_param_comp_3 = Cond_model{3,roi_comp}{1}.sigma;
            
          
            
        case 'Y_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.y;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.y;
            x_param_comp_3 = Cond_model{3,roi_comp}{1}.y;
            
          
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
            y_param_comp_3 = Cond_model{3,roi_comp}{1}.sigma;
            
            
    end
    
 %%   
    %---------- plot Raw data----------------%
   
    fprintf('\n Plotting raw data for roi %d \n',roi_idx);
    
    % Plot the fit line
    figName = sprintf('%s vs eccentricity',yAxis);
    figPoint_dist = figure; set(gcf, 'Color', 'w', 'Position',[100 100 1920/2 1080/2], 'Name', figName); 
    subplot(2,1,1);
    plot(x_param_comp_1,y_param_comp_1,'.','color',[0.3010, 0.7450, 0.9330],'MarkerSize',10); 
    xlabel('eccentricity'); ylabel('pRF size');
    subplot(2,1,2);
    plot(x_param_comp_1,z_param_comp_1,'.','color',[0.3010, 0.7450, 0.9330],'MarkerSize',10);     
    titleall = sprintf('%s', roi_comp) ;
    title(titleall);
    xlabel('eccentricity'); ylabel('variance explained');
    ylim([0 1]);
    xlim(xaxislim);
   
    figPoint_dist = figure; set(gcf, 'Color', 'w', 'Position',[100 100 1920/2 1080/2], 'Name', figName); 
    subplot(2,1,1);
    plot(x_param_comp_2,y_param_comp_2,'.','color',[0.5 1 0.5],'MarkerSize',10);
    xlabel('eccentricity'); ylabel('pRF size');
    subplot(2,1,2);
    plot(x_param_comp_2,z_param_comp_2,'.','color',[0.5 1 0.5],'MarkerSize',10); 
    titleall = sprintf('%s', roi_comp) ;
    title(titleall);
    xlabel('eccentricity'); ylabel('variance explained');
    ylim([0 1]);
    xlim(xaxislim);
    
    figPoint_dist = figure; set(gcf, 'Color', 'w', 'Position',[100 100 1920/2 1080/2], 'Name', figName); 
    subplot(2,1,1);
    plot(x_param_comp_3,y_param_comp_3,'.','color',[1 0.5 0.5],'MarkerSize',10);
    xlabel('eccentricity'); ylabel('pRF size');
    subplot(2,1,2);
    plot(x_param_comp_3,z_param_comp_3,'.','color',[1 0.5 0.5],'MarkerSize',10); 
    titleall = sprintf('%s', roi_comp) ;
    title(titleall);
    xlabel('eccentricity'); ylabel('variance explained');
    ylim([0 1]);
    xlim(xaxislim);
          
    hold off;
    fprintf('\n Done \n');

%%   
    
    %---------- Plot the fit line and mean values in the bins -----------%
    
    fprintf('\n Calculating slope and intercept for the best fitting line for the conditions for roi %d \n',roi_idx)
    
    % Do a linear regression of the two parameters weighted with the variance explained    
    % Steps:
    % Fit a line to the distribution of points weighted with their variance
    % explained
    % Determine the line at the points given by xfit.
    xfit = linspace(xfit_range(1),xfit_range(2),20)'; 
    [param_comp_1_yfit] = NP_fit(x_param_comp_1,y_param_comp_1,Cond_model{1,roi_comp}{1}.varexp,xfit);
    [param_comp_2_yfit] = NP_fit(x_param_comp_2,y_param_comp_2,Cond_model{2,roi_comp}{1}.varexp,xfit);
    [param_comp_3_yfit] = NP_fit(x_param_comp_3,y_param_comp_3,Cond_model{3,roi_comp}{1}.varexp,xfit);
        
    figName = sprintf('%s vs eccentricity',yAxis);
    figPoint_fit = figure; set(gcf, 'Color', 'w', 'Position',[100 100 1920/2 1080/2], 'Name', figName); hold on;
    % Plot the fit line 
    hold on;
    plot(xfit,param_comp_1_yfit','color','b','LineWidth',2); hold on;
    plot(xfit,param_comp_2_yfit','color','g','LineWidth',2); hold on;
    plot(xfit,param_comp_3_yfit','color','r','LineWidth',2); hold on;
        
    fprintf('Binning and bootstrapping the data for roi %d \n',roi_idx')

    %figName = sprintf('%s vs eccentricity',yAxis);
    %figPoint_fit = figure; set(gcf, 'Color', 'w', 'Position',[100 100 1920 1080], 'Name', figName); hold on;
    % steps:
    % bin the data, 
    % calculate the mean, 
    % fit a line to the mean
    
    eccThr = opt.eccThr;
    % Bootstrap the data and bin the x parameter 
    [param_comp_1_data,param_comp_1_b_xfit,param_comp_1_b_upper,param_comp_1_b_lower,~] = SF_bin_param(x_param_comp_1,y_param_comp_1,Cond_model{1,roi_comp}{1}.varexp,eccThr,opt);
    [param_comp_2_data,param_comp_2_b_xfit,param_comp_2_b_upper,param_comp_2_b_lower,~] = SF_bin_param(x_param_comp_2,y_param_comp_2,Cond_model{2,roi_comp}{1}.varexp,eccThr,opt);
    [param_comp_3_data,param_comp_3_b_xfit,param_comp_3_b_upper,param_comp_3_b_lower,~] = SF_bin_param(x_param_comp_3,y_param_comp_3,Cond_model{3,roi_comp}{1}.varexp,eccThr,opt);
    hold on;  
    patch([param_comp_1_b_xfit, fliplr(param_comp_1_b_xfit)], [param_comp_1_b_lower', fliplr(param_comp_1_b_upper')], [0.3010, 0.7450, 0.9330], 'FaceAlpha', 0.5, 'LineStyle','none');
    patch([param_comp_2_b_xfit, fliplr(param_comp_2_b_xfit)], [param_comp_2_b_lower', fliplr(param_comp_2_b_upper')], [0.4 1 0.4], 'FaceAlpha', 0.5, 'LineStyle','none');
    patch([param_comp_3_b_xfit, fliplr(param_comp_3_b_xfit)], [param_comp_3_b_lower', fliplr(param_comp_3_b_upper')], [1 0.4 0.4], 'FaceAlpha', 0.5, 'LineStyle','none');
        
    hold on;
    errorbar(param_comp_1_data.x,param_comp_1_data.y,param_comp_1_data.ysterr,'bo','MarkerFaceColor','b','MarkerSize',MarkerSize);
    errorbar(param_comp_2_data.x,param_comp_2_data.y,param_comp_2_data.ysterr,'go','MarkerFaceColor','g','MarkerSize',MarkerSize);
    errorbar(param_comp_3_data.x,param_comp_3_data.y,param_comp_3_data.ysterr,'ro','MarkerFaceColor','r','MarkerSize',MarkerSize);
    xlabel('eccentricity'); ylabel('pRF size');
    titleall = sprintf('%s', roi_comp) ;
    title(titleall);
    legend([{data_comp_1},{data_comp_2},{data_comp_3},'Location','northWest');
    ylim(yaxislim);
    xlim(xaxislim);
    
    hold off;
%     
%%    
    
    %------- Plot the central values------------%
    % Calculate the central value from the fit
    % Bootstrap the data and bin the x parameter     
    
    if opt.centralVal
        
        fprintf('\n Binning the data, bootstrapping the bins and caluculating the median, 97.5 and 2.5 percent confidence interval for roi %d \n',roi_idx)
        
        param_comp_1_data_cen = NP_central_val(param_comp_1_b_xfit,param_comp_1_yfit,param_comp_1_b_upper,param_comp_1_b_lower,xfit);
        param_comp_2_data_cen = NP_central_val(param_comp_2_b_xfit,param_comp_2_yfit,param_comp_2_b_upper,param_comp_2_b_lower,xfit);
        param_comp_3_data_cen = NP_central_val(param_comp_3_b_xfit,param_comp_3_yfit,param_comp_3_b_upper,param_comp_3_b_lower,xfit);
                
        figPoint_cen = figure;
        h = bar([param_comp_1_data_cen.y,nan],'FaceColor',[0 0 1]);hold on;
        bar([nan,param_comp_2_data_cen.y],'FaceColor',[0 1 0]);hold on;
        errorbar([1,2],[param_comp_1_data_cen.y,param_comp_2_data_cen.y],[param_comp_1_data_cen.y-param_comp_1_data_cen.lo,param_comp_2_data_cen.y-param_comp_2_data_cen.lo],[param_comp_1_data_cen.up-param_comp_1_data_cen.y,param_comp_2_data_cen.up-param_comp_2_data_cen.y],'k','LineStyle','none');
        xlim([0 3]);
        ylim(yaxislim);
        titleall = sprintf('%s', roi_comp) ;
        title(titleall);
        hold off;
        set(h.Parent,'XTickLabel',[{data_comp_1},{data_comp_3}]);
        
        % Scrambled - Natural (all rois)
        param_comp_diff_data_cen_allroi(roi_idx) = param_comp_2_data_cen.y - param_comp_1_data_cen.y;
        
% --Calculate the difference between the sigma values and then calculate the central values
        
        % Calculate the difference between sigma values, bin them and bootstrap across bins
        assertEqual(x_param_comp_1,x_param_comp_2);
        x_param_comp = x_param_comp_1;
        
        [~,param_comp_b_xfit_diff,param_comp_b_upper_diff,param_comp_b_lower_diff,param_comp_b_y] = NP_bin_param(x_param_comp,((y_param_comp_2-y_param_comp_1)./((y_param_comp_2+y_param_comp_1)./2)),[],xfit);
        
        param_comp_data_diff_cen = NP_central_val(param_comp_b_xfit_diff,param_comp_b_y,param_comp_b_upper_diff,param_comp_b_lower_diff,xfit);
        param_comp_diff_data_cen_allroi_bin(roi_idx,1) = param_comp_data_diff_cen.y;
        param_comp_diff_data_cen_allroi_up(roi_idx,1) = param_comp_data_diff_cen.up;
        param_comp_diff_data_cen_allroi_lo(roi_idx,1) = param_comp_data_diff_cen.lo;
        
    end
    
%%     
    %---------Plot the Area under curve-----------%
   
    if opt.AUC
        
        fprintf('\n Calculating the area under the curve for roi %d \n',roi_idx);
        
        param_comp_1_auc = trapz(xfit,param_comp_1_yfit);
        param_comp_2_auc = trapz(xfit,param_comp_2_yfit);
        param_comp_3_auc = trapz(xfit,param_comp_3_yfit);
                
        figPoint_auc = figure;
        h = bar([param_comp_1_auc,nan,nan,nan],'FaceColor',[0.3010, 0.7450, 0.9330]);hold on;
        bar([nan,param_comp_2_auc,nan,nan],'FaceColor',[0.4 1 0.4]);hold on;
        bar([nan,nan,param_comp_3_auc,nan],'FaceColor',[1 0.4 0.4]);hold on;
        ylabel('AUC');
        xlim([0 5]);
        ylim([0 15]);
        titleall = sprintf('%s', roi_comp) ;
        title(titleall);
        hold off;
        set(h.Parent,'XTickLabel',[{data_comp_1},{data_comp_2},{data_comp_3},{data_comp_4}]);
        
    end
   
%%
    
 %-----------------------------------------
    fprintf('\n Saving the plots for roi %d \n',roi_idx)
    
    if opt.saveFig == 1
        filename_raw = strcat(save_dir, '/', 'plot', roi_comp,'raw', '.png');
        saveas(figPoint_raw,filename_raw);
        
        filename_fit = strcat(save_dir, '/', 'plot', roi_comp,'fit', '.png');
        saveas(figPoint_fit,filename_fit);
        
        filename_cen = strcat(save_dir, '/', 'plot', roi_comp,'central', '.png');
        saveas(figPoint_cen,filename_cen);
        
        filename_auc = strcat(save_dir, '/', 'plot', roi_comp,'auc', '.png');
        saveas(figPoint_auc,filename_auc);
        
    end
    
end

%% Save the plots and results
if opt.saveData
    % save the results
    save(strcat(save_dir,'/','results.mat'),'Cond_model','ROI_params');
    
end

%close all;
end


   



