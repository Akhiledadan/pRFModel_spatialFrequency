function SF_stimImGen(freq,save_dir,varargin)
% generating images with different spatial ferquencies and random
% orientations

rms_clip_check = 0;
numOfIm = 1;
if exist('varargin','var') || ~isempty(varargin)
for n = 1:2:numel(varargin)
    data = varargin{n+1};
    
    switch lower(varargin{n})
        case {'rms_clip_check'}
            if ischar(data)
                data = str2double(data);
            end
            rms_clip_check = data;
            
        case {'num_im'}
            if ischar(data)
                data = str2double(data);
            end
            numOfIm = data;
    end
end
end
    
if ~exist('save_dir','var') || isempty(save_dir)
    save_dir = pwd;
end


%[x,y] =  meshgrid(-2.575:0.01:2.575);

display.screensizeinpixels = 1080;
display.height = 39.29;
display.distance = 220;
display.screensizeindeg = rad2deg(atan(display.height./(2*display.distance))); % radius
display.stepsindeg = linspace(-display.screensizeindeg,display.screensizeindeg,display.screensizeinpixels);

[x,~] =  meshgrid(display.stepsindeg);



% Constant RMS contrast for all the images (randomly selected to be 10 for now)
rmscontrastimages = 10;

% Open parallel pool
par_comp = 0;


for f = 1:numel(freq)
    this_freq = freq(f);
    % Randomizing the phase and orientation
    s_rndPh_rndOrn = struct;
    num_im =1;
    if par_comp == 1
        n_cores = 3;
        open_parallel_pool(n_cores);
        
        parfor i =1:numOfIm
            % Genrating the sine wave with frequency = cycles / deg
            s_orig = sin(2*pi*this_freq*x + rand(1)*2*pi); % + add random phase to sinewave
            pp = powerspec(s_orig);
            
            s = randphase(s_orig,1);
            
            %s = s*0.5*2+0.5;
            
            s = s*128*2+128; % scaling the values close to 255 before running through rmscale
            [~, s] = rmsscale(s,rmscontrastimages,[0 255]); % make the same contrast
            
            s = round(s);
            pp2 = powerspec(s);
            a = imagestat(s);
            
            s_rndPh_rndOrn(i).image = s;
            s_rndPh_rndOrn(i).contrast = a.contrast;
            s_rndPh_rndOrn(i).pp = pp2;
            
            
        end
        
        
    elseif par_comp == 0
        
        
        if rms_clip_check == 1
            
            while num_im < 100
                
                %for i =1:numOfIm
                % Genrating the sine wave with frequency = cycles / deg
                s_orig = sin(2*pi*this_freq*x + rand(1)*2*pi); % + add random phase to sinewave
                pp = powerspec(s_orig);
                
                s = randphase(s_orig,1);
                
                %s = s*0.5*2+0.5;
                
                
                s = s*128*2+128; % scaling the values close to 255 before running through rmscale
                [~, s,~,w] = rmsscale(s,rmscontrastimages,[0 255]); % make the same contrast
                
                s = round(s);
                pp2 = powerspec(s);
                a = imagestat(s);
                
                if w~=1
                    
                    s_rndPh_rndOrn(num_im).image = s;
                    s_rndPh_rndOrn(num_im).contrast = a.contrast;
                    s_rndPh_rndOrn(num_im).pp = pp2;
                    num_im = num_im+1;
                    
                    if rem(num_im,5) == 0
                        fprintf('\n%d..',num_im);
                    end
                end
                
                %end
            end
            
        else
            for i =1:numOfIm
                % Genrating the sine wave with frequency = cycles / deg
                s_orig = sin(2*pi*this_freq*x + rand(1)*2*pi); % + add random phase to sinewave
                pp = powerspec(s_orig);
                
                s = randphase(s_orig,1);
                
                %s = s*0.5*2+0.5;
                
                
                s = s*128*2+128; % scaling the values close to 255 before running through rmscale
                [~, s,~,w] = rmsscale(s,rmscontrastimages,[0 255]); % make the same contrast
                
                s = round(s);
                pp2 = powerspec(s);
                a = imagestat(s);
                
                if w~=1
                    
                    s_rndPh_rndOrn(num_im).image = s;
                    s_rndPh_rndOrn(num_im).contrast = a.contrast;
                    s_rndPh_rndOrn(num_im).pp = pp2;
                    num_im = num_im+1;
                    
                    if rem(num_im,5) == 0
                        fprintf('\n%d..',num_im);
                    end
                end
                
            end
            
        end
        
        fprintf('Saving images for frequency %d cycles/degree \n',this_freq);
        f_name = strcat('retinotopyimg_SF_',num2str(this_freq),'.mat');
        ff_path = fullfile(save_dir,f_name);
        save(ff_path,'s_rndPh_rndOrn');
        
    end
    
    
    f_name_display = strcat('display','.mat');
    ff_path_display = fullfile(save_dir,f_name_display);
    save(ff_path_display,'display');
    
    if par_comp == 1
        delete(gcp);
    end
    
    % pp = powerspec(s);
    % pps = powerspec(s_rndPh_rndOrn(1).image);
    % x0 = linspace(0,display.screensizeinpixels/(2*display.screensizeindeg)/2,display.screensizeinpixels/2+1);
    %
    % figure;loglog(x0,pps);
    %
    % % Calculating the frqeuncy spectrum of the images
    % npts = size(x,1);
    % im_s = s_rndPh_rndOrn(1).image;
    % S = fft2(im_s);
    % S_amp = 2*abs(S)/npts;
    % S_amp_shft = fftshift(S_amp);
    % hz = linspace(0,srate/2,floor(npts/2)+1);
    % figure, plot(hz,S_amp_shft(1:length(hz)));
    %
    %
    %
    % tmp = fftshift(fft2(im_s));
    %
    %
    % figure, imagesc(-2.575:0.01:2.575,-2.575:0.01:2.575,abs(tmp));
    
end