function SF_plotRawParameters(params_comp,opt,dirPth)

% Define the different conditions to be compared
conditions = opt.conditions;
numCond = length(conditions);

% change colors here
color_map = [1 0.75 0.75;...
    0.75 1 0.75;...
    0.75 0.75 1;...
    0.75 0.75 0.75];

rois = opt.rois;
numRoi = length(rois);


% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi',opt.subjID,opt.yAxis);
fH2 = figure(2); clf;
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

% Plot the variance explained
figName = sprintf('%s VE vs eccentricity roi',opt.subjID);
fH21 = figure(21); clf;
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

numRows = 1;
numCols = numCond;

for cond_idx = 1:numCond
    curCond = conditions{cond_idx};

    figure(2); ax2 = subplot(numRows,numCols,cond_idx);
    figure(21); ax21 = subplot(numRows,numCols,cond_idx);
    
    for roi_idx = 1:numRoi
  
        curRoi = opt.rois{roi_idx};
      
        figure(2); hold on;
        plot(params_comp.x_comp{cond_idx,roi_idx},params_comp.y_comp{cond_idx,roi_idx},'.','color',color_map(roi_idx,:),'MarkerSize',10);
        xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
        ylim(opt.yaxislim);
        xlim(opt.xaxislim);
        legend(opt.rois);

        figure(21); hold on;
        plot(params_comp.x_comp{cond_idx,roi_idx},params_comp.ve_comp{cond_idx,roi_idx},'.','color',color_map(roi_idx,:),'MarkerSize',10);
        xlabel('eccentricity (deg)'); ylabel('variance explained (%)');
        ylim([0 1]);
        xlim(opt.xaxislim);

        
    end
    set(ax2, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    set(ax21, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    
end


if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure2');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH2, fullfile(saveDir,strcat(filename,'_raw_conditions')), '-dpng');
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH21, fullfile(saveDir,strcat(filename,'_ve_conditions')), '-dpng');
end



%% Figure split into rois 


% Define the different conditions to be compared
conditions = opt.conditions;
numCond = length(conditions);


rois = opt.rois;
numRoi = length(rois);


% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi',opt.subjID,opt.yAxis);
fH3 = figure(3); clf;
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

% Plot the variance explained
figName = sprintf('%s VE vs eccentricity roi',opt.subjID);
fH31 = figure(31); clf;
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

numRows = 1;
numCols = numCond;

for roi_idx = 1:numRoi
    curRoi = opt.rois{roi_idx};
    
    
    figure(3); ax3 = subplot(numRows,numCols,roi_idx);
    figure(31); ax31 = subplot(numRows,numCols,roi_idx);
    
    for cond_idx = 1:numCond
        
        curCond = conditions{cond_idx};
        
        figure(3); hold on;
        plot(params_comp.x_comp{cond_idx,roi_idx},params_comp.y_comp{cond_idx,roi_idx},'.','color',color_map(cond_idx,:),'MarkerSize',10);
        xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
        ylim(opt.yaxislim);
        xlim(opt.xaxislim);
        legend(opt.conditions);
        
        figure(31); hold on;
        plot(params_comp.x_comp{cond_idx,roi_idx},params_comp.ve_comp{cond_idx,roi_idx},'.','color',color_map(cond_idx,:),'MarkerSize',10);
        xlabel('eccentricity (deg)'); ylabel('variance explained (%)');
        ylim([0 1]);
        xlim(opt.xaxislim);
        
        
    end
    set(ax3, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    set(ax31, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off    
    
end

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure2');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH3, fullfile(saveDir,strcat(filename,'_raw_rois')), '-dpng');
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH31, fullfile(saveDir,strcat(filename,'_ve_rois')), '-dpng');
end


%% Figure split into rois and conditions


% Define the different conditions to be compared
conditions = opt.conditions;
numCond = length(conditions);

% change colors here
color_map_all = {[1 0.25 0.25],[0.25 1 0.25],[0.25 0.25 1];...
                 [1 0.5 0.5],[0.5 1 0.5],[0.5 0.5 1];...
                 [1 0.75 0.75],[0.75 1 0.75],[0.75 0.75 1]};


rois = opt.rois;
numRoi = length(rois);


% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi',opt.subjID,opt.yAxis);
fH4 = figure(4); clf;
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

% Plot the variance explained
figName = sprintf('%s VE vs eccentricity roi',opt.subjID);
fH41 = figure(41); clf;
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

numRows = numRoi;
numCols = numCond;

curPos = 1;
for roi_idx = 1:numRoi
            curRoi = opt.rois{roi_idx};

    
    for cond_idx = 1:numCond        
        
    curCond = opt.conditions{cond_idx};
        
        figure(4); ax4 = subplot(numRows,numCols,curPos);
        figure(41); ax41 = subplot(numRows,numCols,curPos);

        curPos = curPos + 1;
        
        
        figure(4); hold on;
        plot(params_comp.x_comp{cond_idx,roi_idx},params_comp.y_comp{cond_idx,roi_idx},'.','color',color_map_all{cond_idx,roi_idx},'MarkerSize',10);
        xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
        ylim(opt.yaxislim);
        xlim(opt.xaxislim);
        legend(sprintf('%s,%s',opt.conditions{cond_idx},opt.rois{roi_idx}));
        
        figure(41); hold on;
        plot(params_comp.x_comp{cond_idx,roi_idx},params_comp.ve_comp{cond_idx,roi_idx},'.','color',color_map_all{cond_idx,roi_idx},'MarkerSize',10);
        xlabel('eccentricity (deg)'); ylabel('variance explained (%)');
        legend(sprintf('%s,%s',opt.conditions{cond_idx},opt.rois{roi_idx}));
        ylim([0 1]);
        xlim(opt.xaxislim);
        
        set(ax4, 'FontUnits','centimeters','FontSize',0.5, 'TickDir','out','LineWidth',3); box off
        set(ax41, 'FontUnits','centimeters','FontSize',0.5, 'TickDir','out','LineWidth',3); box off
        
    end

    
end

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure2');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH4, fullfile(saveDir,strcat(filename,'_raw_rois')), '-dpng');
    
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH41, fullfile(saveDir,strcat(filename,'_ve_rois_conditions')), '-dpng');
end

end