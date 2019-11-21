function SF_averagePlots_bin(params_comp_all,opt,dirPth)

numSub  = size(params_comp_all.bin,2);
numCond = size(params_comp_all.bin{1}.binVal_comp,1);
numRoi  = size(params_comp_all.bin{1}.binVal_comp,2);
for sub_idx = 1:numSub
    for cond_idx = 1:numCond
        for roi_idx = 1:numRoi
            bin_x(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.x;
            bin_y(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.y;
            bin_ystdev(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.ystdev;
            bin_ysterr(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.ysterr;
        end
    end
end

%%
% plot all the subject binned values
% change colors here
color_map = [1 0.5 0.5;...
    0.5 1 0.5;...
    0.5 0.5 1;...
    0.5 0.5 0.5];

fH200= figure(200); figName_binInd = 'bin ind';
set(gcf,'position',[66,1,1855,1001])

for sub_idx = 1:numSub
    for cond_idx = 1:numCond
        
         
        for roi_idx = 1:numRoi
            ax = subplot(1,numRoi,roi_idx);
            
            errorbar(bin_x(:,cond_idx,roi_idx,sub_idx),bin_y(:,cond_idx,roi_idx,sub_idx),bin_ysterr(:,cond_idx,roi_idx,sub_idx),'.','color',color_map(cond_idx,:),...
                'LineStyle','-','MarkerSize',20,'HandleVisibility','on','LineWidth',2,'CapSize',10);
            xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
            ylim([0.4 1.7]);
            xlim([0 5]);
            legend({'3';'6';'12'},'location','NorthWest');
            hold on;
            set(ax, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off            
        end

    end
end

%%
% Average mean at each bin across subjects
numBin = size(bin_y,1);
if opt.bin_wMean
    for cond_idx = 1:numCond
        for roi_idx = 1:numRoi
            for bin_idx = 1:numBin
                w = 1./ bin_ystdev(bin_idx,cond_idx,roi_idx,:);
                bin_stats = wstat(bin_y(bin_idx,cond_idx,roi_idx,:),w);
                bin_y_aveSub(bin_idx,cond_idx,roi_idx) = bin_stats.mean;
                bin_y_stdSub(bin_idx,cond_idx,roi_idx) = bin_stats.stdev;
                bin_y_sterrSub(bin_idx,cond_idx,roi_idx) = bin_stats.sterr;
            end
        end
    end
    
else
    bin_y_aveSub = mean(bin_y,4);
    bin_y_stdSub = std(bin_y,[],4);
    bin_y_sterrSub = bin_y_stdSub ./ sqrt(numSub);
end



fH300= figure(300); figName_binAll = 'bin all';
set(gcf,'position',[66,1,1855,1001])
for cond_idx = 1:numCond
    for roi_idx = 1:numRoi
        ax = subplot(1,numRoi,roi_idx);
        
        errorbar(bin_x(:,cond_idx,roi_idx,1),bin_y_aveSub(:,cond_idx,roi_idx),bin_y_sterrSub(:,cond_idx,roi_idx),'.','color',color_map(cond_idx,:),...
            'LineStyle','-','MarkerSize',20,'HandleVisibility','on','LineWidth',2,'CapSize',10);
        xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
        ylim([0.4 1.7]);
        xlim([0 5]);
        legend({'3';'6';'12'},'location','NorthWest');
        hold on;
        set(ax, 'FontUnits','centimeters','FontSize',1.1, 'TickDir','out','LineWidth',3); box off
    end
end

%%
if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure5');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
    figName_binInd(regexp(figName_binInd,' ')) = '_';
    filename = figName_binInd;
    print(fH200, fullfile(saveDir,strcat(filename,'_bin_ind')), '-dpng');
    
    
    figName_binAll(regexp(figName_binAll,' ')) = '_';
    filename = figName_binAll;
    print(fH300, fullfile(saveDir,strcat(filename,'_bin_all')), '-dpng');
end


end