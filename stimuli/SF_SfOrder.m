% SF_SfOrder: Loads stimulus file and outputs which spatial frequency
% condition was presented and the corresponding fixation dot
% performance
%
% written by Akhil Edadan (a.edadan@uu.nl)

sub = dir('*.mat');
subjects = {'dlsubj127'};

for sub_idx = 3:length(sub)

curSub = subjects{sub_idx};    
subFuncDir = sprintf('/data1/projects/dumoulinlab/Lab_members/Akhil/SF/data/functionals/%s/3_6_12_18/Session_2/EPI',curSub);    
scan = dir('*.nii');

for scan_idx = 1:length(scan)
    filename = {scan.name}
    [~,idx] = sort(str2double(regexp(filename,'\d+(?=\_1-d0224_deob.nii$)','match','once')));
    D = filename(idx);
%     D
% 
%     [~, SF] = regexp(D, 'SF\d', 'match', 'once')
%     SF_nr = D(SF)
%     SF_nr{:}
end    
    
     
    
cd (sub(sub_idx).name);    

stim = dir(pwd);

numStimFiles = length(stim)-2;
fprintf('Subject %s \t %d \n', sub(sub_idx).name,numStimFiles);

for stim_idx = 3:length(stim)
    
   tmp  = load(fullfile(stim(stim_idx).folder,stim(stim_idx).name));
    
   fprintf('loading %s \t',stim(stim_idx).name)

   sf = tmp.params.spfreq; 
   pc  = tmp.pc;
   
   %[pc_recalculated,rc_recalculated] = getFixationPerformance(tmp.params.fix,tmp.stimulus,tmp.response);
   
   fprintf('%s \t\t %1.f \t %s \n',sf,pc,D);
       
   clear tmp;
end

cd ..

end





