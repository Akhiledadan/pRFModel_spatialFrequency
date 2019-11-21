% add the necessary matlab scripts to the path
% addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/pRFModel_spatialFrequency')); % spatial frequency scripts
% addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/external/vistasoft')); % vistasoft -  https://github.com/vistalab/vistasoft

%%
bb = 0; % flag for using broadband data for comparison 
all = 1;

if ~bb
    if all
        % subject names
        subjects = {'dlsub003','dlsub099','dlsub120','dlsub123','dlsub126','dlsub127','dlsub128','dlsub133','dlsub134','dlsub135'};
    else
        % for comparison with broadband (4 overlapping subjects)
        subjects = {'dlsub003','dlsub123','dlsub127','dlsub128'};
    end
    
else
    % for comparison with broadband (4 overlapping subjects)
    subjects = {'dlsub003','dlsub123','dlsub127','dlsub128'};
end

% for testing       
%subjects = {'dlsub003'};   

%%
% load prf model files, and extract the reuiqred parameters (fit, bin, auc,
% central values) from every subject
params_comp_all = SF_prfPropertiesCompare(subjects,bb);


%%
% plot average responses across subjects - AUC and central values and
% binned mean values
opt.verbose =1;
if opt.verbose
    
    opt.saveFig = 1;
    if ~bb
        dirPth.saveDirMSFig = fullfile(SF_rootPath,'data','MS','figures');
    else
        dirPth.saveDirMSFig = fullfile(SF_rootPath,'data','MS','figures_bb');
    end
    
    
    opt.bin_wMean = 1;
    % Average the binned values across subjects
    SF_averagePlots_bin(params_comp_all,opt,dirPth);
    
    % Average the auc and central values across subjects
    SF_averagePlots(params_comp_all,opt,dirPth);
end


%%
bb = 1;
opt.verbose =1;
if opt.verbose
    
    opt.saveFig = 1;
    if ~bb
        dirPth.saveDirMSFig = fullfile(SF_rootPath,'data','MS','figures');
    else
        dirPth.saveDirMSFig = fullfile(SF_rootPath,'data','MS','figures_bb');
    end
    
    % Average the auc and central values across subjects
    SF_averagePlots_bb(params_comp_all,opt,dirPth);
end



%% Stats

opt.roisToCompare = 'V123';
opt.paramToCompare = 'auc';

fprintf('parameter: %s \t rois: %s',opt.paramToCompare,opt.roisToCompare);

stats_folder = '/home/edadan/SF/data/MS/stats_results';
SF_oneWayAnova(opt,stats_folder,0);



%SF_stats(paramsToCompare,paramsToCompare_type,rois); 
