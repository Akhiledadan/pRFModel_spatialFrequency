function SF_averagePlots(params_comp_all,opt,dirPth)

% subject average - central value
% subject average - AUC


numSub = size(params_comp_all.cen,3);


central_average = mean(params_comp_all.cen,3);
central_std = std(params_comp_all.cen,[],3);
central_sterr = central_std ./ sqrt(numSub);

figName_cen = 'Central';
fH100 = figure(100); set(gcf,'position',[66,1,1855,1001]);
bar(central_average'); hold on;
h = errorbar_group(central_average',central_sterr');
h(1).FaceColor = [0.5 1 0.5];
h(2).FaceColor = [0.5 0.5 1];
h(3).FaceColor = [1 0.5 0.5];
xlim([0 4]);
ylim([0 inf]);
xlabel('Visual field maps');
ylabel('pRF size (degrees)');
set(gca,'XTickLabel',{'V1';'V2';'V3'});
set(gca,'FontSize',15,'TickDir','out','LineWidth',3); box off;

% Area under curve
auc_average = mean(params_comp_all.auc,3);
auc_std = std(params_comp_all.auc,[],3);
auc_sterr = auc_std ./ sqrt(numSub);

figName_auc = 'AUC';
fH101 = figure(101); set(gcf,'position',[66,1,1855,1001]);
bar(auc_average'); hold on;
h = errorbar_group(auc_average',auc_sterr');
h(1).FaceColor = [1 0.5 0.5];
h(2).FaceColor = [0.5 1 0.5];
h(3).FaceColor = [0.5 0.5 1];
xlim([0 4]);
ylim([0 inf]);
xlabel('Visual field maps');
ylabel('Area under curve');
set(gca,'XTickLabel',{'V1';'V2';'V3'});
set(gca,'FontSize',15,'TickDir','out','LineWidth',3); box off;


if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure4');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    figName(regexp(figName_cen,' ')) = '_';
    filename = figName;
    print(fH100, fullfile(saveDir,strcat(filename,'_central_all')), '-dpng');
    
    
    figName(regexp(figName_auc,' ')) = '_';
    filename = figName;
    print(fH101, fullfile(saveDir,strcat(filename,'_auc_all')), '-dpng');
end


end