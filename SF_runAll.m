subjects = {'dlsub003',...
            'dlsub099',...
            'dlsub120',...
            'dlsub123',...
            'dlsub126',...
            'dlsub127',...
            'dlsub134',...
            };
  
        
% subject dlsub128 not run (DV is rerunning vistasession)        
        
% for testing       
% subjects = {'dlsub134'};   

%subjects = {'dlsub128'};        
params_comp_all = SF_prfPropertiesCompare(subjects);

% Average the binned values across subjects
numSub  = size(params_comp_all.bin,2);
numCond = size(params_comp_all.bin{1}.binVal_comp,1);
numRoi  = size(params_comp_all.bin{1}.binVal_comp,2);
for sub_idx = 1:numSub
    for cond_idx = 1:numCond
        for roi_idx = 1:numRoi
            bin_x(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.x;
            bin_y(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.y;
            bin_ysterr(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.ysterr;
        end
    end
end

% plot all the subject binned values
% change colors here
color_map = [1 0.5 0.5;...
    0.5 1 0.5;...
    0.5 0.5 1;...
    0.5 0.5 0.5];

fH200= figure(200); set(gcf,'position',[66,1,1855,1001])

for sub_idx = 1:numSub
    for cond_idx = 1:numCond
        
         
        for roi_idx = 1:numRoi
            ax = subplot(1,numRoi,roi_idx);
            
            errorbar(bin_x(:,cond_idx,roi_idx,sub_idx),bin_y(:,cond_idx,roi_idx,sub_idx),bin_ysterr(:,cond_idx,roi_idx,sub_idx),'.','color',color_map(cond_idx,:),...
                'LineStyle','-','MarkerSize',20,'HandleVisibility','on','LineWidth',2,'CapSize',10);
            xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
            ylim([0 3]);
            xlim([0 5]);
            legend({'3';'6';'12'},'location','NorthWest');
            hold on;
            set(ax, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off            
        end

    end
end

% Average across subjects of the mean at each bin 

bin_y_aveSub = mean(bin_y,4);
bin_y_stdSub = std(bin_y,[],4);
bin_y_sterrSub = bin_y_stdSub ./ sqrt(numSub);

fH300= figure(300); set(gcf,'position',[66,1,1855,1001])
for cond_idx = 1:numCond
    for roi_idx = 1:numRoi
        ax = subplot(1,numRoi,roi_idx);
        
        errorbar(bin_x(:,cond_idx,roi_idx,1),bin_y_aveSub(:,cond_idx,roi_idx),bin_y_sterrSub(:,cond_idx,roi_idx),'.','color',color_map(cond_idx,:),...
            'LineStyle','-','MarkerSize',20,'HandleVisibility','on','LineWidth',2,'CapSize',10);
        xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
        ylim([0 3]);
        xlim([0 5]);
        legend({'3';'6';'12'},'location','NorthWest');
        hold on;
        set(ax, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    end
end

opt.verbose =1;
if opt.verbose
    % plot average responses across subjects - AUC and central values 
    opt.saveFig = 1;
    dirPth.saveDirMSFig = fullfile(SF_rootPath,'data','MS','figures');
    SF_averagePlots(params_comp_all,opt,dirPth);
end


%% Stats -  repeated measures ANOVA
% parameters
paramsToCompare      = 'auc';
paramsToCompare_type = 'absolute';
rois = 'V123';
        
fprintf('parameter: %s \t type: %s \t rois: %s',paramsToCompare,paramsToCompare_type,rois);

SF_stats(paramsToCompare,paramsToCompare_type,rois); 
