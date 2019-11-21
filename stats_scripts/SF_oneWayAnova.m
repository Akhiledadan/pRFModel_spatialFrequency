function SF_oneWayAnova(opt,stats_folder,verbose)
% SZ_repeatedMeasuresAnova - one way ANOVA to comapre between groups
% folder containing results

if ~exist('stats_folder','var')
    stats_folder = '/home/edadan/SF/data/MS/stats_results';
end

if ~exist('verbose','var')
    verbose = false;
end


filename_res = 'cen_auc.mat';


load(fullfile(stats_folder,filename_res),'params_comp_all');

% parameter to compare. Can be either area under curve or central value

if strcmpi(opt.paramToCompare,'central')
    D=params_comp_all.cen; % cond x roi x subjects
elseif strcmpi(opt.paramToCompare,'auc')
    D=params_comp_all.auc;
end


% separate paremeter values into different rois

V1 = squeeze(D(:,1,:))';
V2 = squeeze(D(:,2,:))';
V3 = squeeze(D(:,3,:))';


fprintf('\n V1 \n');

p = anova1(V1)

if p < 0.05
    % t test for individual rois
    [~,p,~,stats]= ttest2(V1(:,1),V1(:,2))
    [~,p,~,stats]= ttest2(V1(:,2),V1(:,3))
    [~,p,~,stats]= ttest2(V1(:,1),V1(:,3))
end



fprintf('\n V2 \n');

p = anova1(V2)

if p < 0.05
    % t test for individual rois
    [~,p,~,stats]= ttest2(V2(:,1),V2(:,2))
    [~,p,~,stats]= ttest2(V2(:,2),V2(:,3))
    [~,p,~,stats]= ttest2(V2(:,1),V2(:,3))
end


fprintf('\n V3 \n');

p = anova1(V3)

if p < 0.05
    % t test for individual rois
    [~,p,~,stats]= ttest2(V3(:,1),V3(:,2))
    [~,p,~,stats]= ttest2(V3(:,2),V3(:,3))
    [~,p,~,stats]= ttest2(V3(:,1),V3(:,3))
end


if verbose
    % to plot the figures
    figure;
    plot(V1','o-r')
    hold on
    plot(V2','o-g')
    plot(V3','o-b')
    plot((mean(V1)/3)*patient(get)','o-k')
end



end