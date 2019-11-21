%SF_Manova
% Function to perform multivariate Analysis of Variance for

numSub  = size(params_comp_all.bin,2);
numCond = size(params_comp_all.bin{1}.binVal_comp,1);
numRoi  = size(params_comp_all.bin{1}.binVal_comp,2);
numBin  = size(params_comp_all.bin{1}.binVal_comp{1,1}.y,2);

bin = nan(numBin,numCond,numRoi,numSub);
for sub_idx = 1:numSub
    for cond_idx = 1:numCond
        for roi_idx = 1:numRoi
            bin(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.y;
            x(:,cond_idx,roi_idx,sub_idx) = params_comp_all.bin{sub_idx}.binVal_comp{cond_idx,roi_idx}.x;
        end
    end
end

V1 = squeeze(bin(:,:,1,:));
V2 = squeeze(bin(:,:,2,:));
V3 = squeeze(bin(:,:,3,:));

x = squeeze(x(:,1,1,1));


if opt.verbose 
%%    
    fh = figure(1); clf;
    set(gcf,'position',[66,1,1855,1001]);

    curRoi = 'V1';
    
    boxplot(squeeze(V1(:,1,:))','positions',[1:4:8*4],'labels',x,'Colors','r','Widths',0.3);hold on;
    h1 = findobj(gca,'tag','Median');
    set(h1,'LineWidth',5);
    boxplot(squeeze(V1(:,2,:))','positions',[2:4:8*4+1],'labels',x,'Colors','g','Widths',0.3);hold on;
    h2 = findobj(gca,'tag','Median');
    set(h2,'LineWidth',5);
    boxplot(squeeze(V1(:,3,:))','positions',[3:4:8*4+2],'labels',x,'Colors','b','Widths',0.3);hold on;
    h3 = findobj(gca,'tag','Median');
    set(h3,'LineWidth',5);
    
    xlabel('bins (degrees)');
    ylabel('pRF size (degrees)');
    title(sprintf('%s',curRoi));
    
    xlim([0 8*4]);
    
    set(gca,'XTick',[2 6 10 14 18 22 26 30],'XTickLabel',x);
    set(gca,'FontSize',20,'TickDir','out','LineWidth',2);
    
%%    
    fh = figure(1); clf;
    set(gcf,'position',[66,1,1855,1001]);
    
    curRoi = 'V2';
    
    boxplot(squeeze(V2(:,1,:))','positions',[1:4:8*4],'labels',x,'Colors','r','Widths',0.3);hold on;
    h1 = findobj(gca,'tag','Median');
    set(h1,'LineWidth',5);
    boxplot(squeeze(V2(:,2,:))','positions',[2:4:8*4+1],'labels',x,'Colors','g','Widths',0.3);hold on;
    h2 = findobj(gca,'tag','Median');
    set(h2,'LineWidth',5);
    boxplot(squeeze(V2(:,3,:))','positions',[3:4:8*4+2],'labels',x,'Colors','b','Widths',0.3);hold on;
    h3 = findobj(gca,'tag','Median');
    set(h3,'LineWidth',5);
    
    xlabel('bins (degrees)');
    ylabel('pRF size (degrees)');
    title(sprintf('%s',curRoi));
    
    xlim([0 8*4]);
    
    set(gca,'XTick',[2 6 10 14 18 22 26 30],'XTickLabel',x);
    set(gca,'FontSize',20,'TickDir','out','LineWidth',2);
    
%%    
    fh = figure(1); clf;
    set(gcf,'position',[66,1,1855,1001]);

    curRoi = 'V3';
    
    boxplot(squeeze(V3(:,1,:))','positions',[1:4:8*4],'labels',x,'Colors','r','Widths',0.3);hold on;
    h1 = findobj(gca,'tag','Median');
    set(h1,'LineWidth',5);
    boxplot(squeeze(V3(:,2,:))','positions',[2:4:8*4+1],'labels',x,'Colors','g','Widths',0.3);hold on;
    h2 = findobj(gca,'tag','Median');
    set(h2,'LineWidth',5);
    boxplot(squeeze(V3(:,3,:))','positions',[3:4:8*4+2],'labels',x,'Colors','b','Widths',0.3);hold on;
    h3 = findobj(gca,'tag','Median');
    set(h3,'LineWidth',5);
    
    xlabel('bins (degrees)');
    ylabel('pRF size (degrees)');
    title(sprintf('%s',curRoi));
    
    xlim([0 8*4]);
    
    set(gca,'XTick',[2 6 10 14 18 22 26 30],'XTickLabel',x);
    set(gca,'FontSize',20,'TickDir','out','LineWidth',2);
    
    
end



