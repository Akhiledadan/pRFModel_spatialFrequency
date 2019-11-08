function SF_plotBin(params_comp,opt,dirPth)


% Define the different conditions to be compared
conditions = opt.conditions;
numCond = length(conditions);

% change colors here
color_map = [1 0 0;...
    0 1 0;...
    0 0 1;...
    0.5 0.5 0.5];

rois = opt.rois;
numRoi = length(rois);


% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi',opt.subjID,opt.yAxis);
fH2 = figure(2); clf; 
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

% Plot the variance explained
% figName = sprintf('%s VE vs eccentricity roi',opt.subjID);
% fH21 = figure(21); clf;
% set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

numRows = 1;
numCols = numCond;

for cond_idx = 1:numCond
    curCond = conditions{cond_idx};
    
    figure(2); ax2 = subplot(numRows,numCols,cond_idx);
    %    figure(21); ax21 = subplot(numRows,numCols,cond_idx);
    
    for roi_idx = 1:numRoi
        
        curRoi = opt.rois{roi_idx};
        
        figure(2); hold on;
        errorbar(params_comp.bin.binVal_comp{cond_idx,roi_idx}.x,params_comp.bin.binVal_comp{cond_idx,roi_idx}.y,params_comp.bin.binVal_comp{cond_idx,roi_idx}.ysterr,'.','color',color_map(roi_idx,:),...
                          'LineStyle','-','MarkerSize',20,'HandleVisibility','on','LineWidth',2,'CapSize',10);
        xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
        ylim([0 2]);
        xlim(opt.xaxislim);
        legend(opt.rois);
        
        % variance explained - fit?
        %         figure(21); hold on;
        %         plot(params_comp.fit.x_fit,params_comp.fit.yfit_comp{cond_idx,roi_idx},'.','color',color_map(roi_idx,:),'MarkerSize',10);
        %         xlabel('eccentricity (deg)'); ylabel('variance explained (%)');
        %         ylim([0 1]);
        %         xlim(opt.xaxislim);
        
        
    end
    set(ax2, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    %    set(ax21, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    
end


if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure2');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH2, fullfile(saveDir,strcat(filename,'_raw_conditions')), '-dpng');
    
    %     figName(regexp(figName,' ')) = '_';
    %     filename = figName;
    %     print(fH21, fullfile(saveDir,strcat(filename,'_ve_conditions')), '-dpng');
end



%% Figure split into rois


% Define the different conditions to be compared
conditions = opt.conditions;
numCond = length(conditions);

% change colors here
color_map = [1 0 0;...
    0 1 0;...
    0 0 1;...
    0.5 0.5 0.5];

rois = opt.rois;
numRoi = length(rois);


% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi',opt.subjID,opt.yAxis);
fH3 = figure(3); clf; 
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

% Plot the variance explained
% figName = sprintf('%s VE vs eccentricity roi',opt.subjID);
% fH31 = figure(31); clf;
% set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

numRows = 1;
numCols = numCond;

for roi_idx = 1:numRoi
    curRoi = opt.rois{roi_idx};
    
    
    figure(3); ax3 = subplot(numRows,numCols,roi_idx);
%    figure(31); ax31 = subplot(numRows,numCols,roi_idx);
    
    for cond_idx = 1:numCond
        
        curCond = conditions{cond_idx};
        
        figure(3); hold on;
        errorbar(params_comp.bin.binVal_comp{cond_idx,roi_idx}.x,params_comp.bin.binVal_comp{cond_idx,roi_idx}.y,params_comp.bin.binVal_comp{cond_idx,roi_idx}.ysterr,'.','color',color_map(cond_idx,:),...
                          'LineStyle','-','MarkerSize',20,'HandleVisibility','on','LineWidth',2,'CapSize',10);
        xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
        ylim([0 2]);
        xlim(opt.xaxislim);
        legend(opt.conditions);
        
        %         figure(31); hold on;
        %         plot(params_comp.x_comp{cond_idx,roi_idx},params_comp.ve_comp{cond_idx,roi_idx},'.','color',color_map(cond_idx,:),'MarkerSize',10);
        %         xlabel('eccentricity (deg)'); ylabel('variance explained (%)');
        %         ylim([0 1]);
        %         xlim(opt.xaxislim);
        
        
    end
    set(ax3, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    %    set(ax31, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    
end

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure3');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH3, fullfile(saveDir,strcat(filename,'_bin_rois')), '-dpng');
    
    %     figName(regexp(figName,' ')) = '_';
    %     filename = figName;
    %     print(fH31, fullfile(saveDir,strcat(filename,'_ve_rois')), '-dpng');
end





end

