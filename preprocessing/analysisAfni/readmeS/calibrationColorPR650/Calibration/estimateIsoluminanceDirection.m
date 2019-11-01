function estimateIsoluminanceDirection
% estimateMidGray - estimate mid isoluminance L/M ratio

% 2013/07 SOD: wrote it

oldLevel = Screen('Preference', 'Verbosity', 1);

% default parameters
params.duration     = 2;
params.nimages      = 2;
params.nindex       = fliplr(round(linspace(0,255,5)));%[0:256/(params.nimages-1)]*(params.nimages-1);
params.quitProgKey  = KbName('q'); 
% empty is no calibration
params.calibration  = '7T_UMC_LCDfixedLens_1024x768';,%[];
% empty is no timing but sunc to button press
params.timing       = [];%[1:length(params.nindex)*3].*params.duration;

if ~isempty(params.calibration),
    params.display = loadDisplayParams('displayName',params.calibration);
    fprintf(1,'[%s]:loading calibration from: %s.\n',mfilename,params.calibration);
else,
    params.display.screenNumber   = max(Screen('screens'));
    [width, height]=Screen('WindowSize',params.display.screenNumber);
    params.display.numPixels  = [width height];
    params.display.cmapDepth  =  8;
    params.display.gammaTable = [0:255]'./255*[1 1 1];
    params.display.gamma      = params.display.gammaTable;
    params.display.backColorRgb   = [128 128 128 255];
    params.display.textColorRgb   = [255 255 255 255];
    params.display.backColorIndex = 128;
    params.display.stimRgbRange   = [0 255];
    params.display.bitsPerPixel   = 32;
    params.display.fixType        = 'disk';
    params.display.fixColorRgb    = [255 0 0];
    params.display.fixX           = width./2;
    params.display.fixY           = height./2;
    params.display.fixSizePixels  = 4;
    
    disp(sprintf('[%s]:no calibration.',mfilename));    
end;
params.display.quitProgKey = params.quitProgKey;
params.display.numColors   = size(params.display.gamma,1);

params.display.devices     = getDevices(false);

% make calibration image
%stimulus.images = zeros(params.display.numPixels(2),params.display.numPixels(1),2,'uint8');
%stimulus.images(:,:,2) = uint8(1);

% colormaps
params.LMScontrast     = 0.02;
% cos(atan(2.8/1))*sqrt(2)
cmapDir = [-1 1 0; -0.4472 3*0.4472 0];
%cmapDir = [1 1 0; sqrt(2) 0 0];
cmap(:,:,1) = create_LMScmap(params.display,cmapDir(1,:).*params.LMScontrast); 
cmap(:,:,2) = create_LMScmap(params.display,cmapDir(2,:).*params.LMScontrast); 
    


key.up   = KbName('u');
key.down = KbName('d');
key.end  = KbName('q');

quitProg = false;
gamma = params.display.gamma.*255;

hz = 4;
freq = round((sin(linspace(0,2*pi*hz,60))./2+0.5).*255);
try,
    % open screen
    params.display = openScreen(params.display);
    
    % Give the display a moment to recover from the change of display mode when
    % opening a window. It takes some monitors and LCD scan converters a few seconds to resync.
    WaitSecs(2);
        % light
        Screen('FillRect', params.display.windowPtr, 255);
        Screen('Flip', params.display.windowPtr);
        WaitSecs(1/15); % approx 30Hz
        
        %dark
        Screen('FillRect', params.display.windowPtr,     0);
        Screen('Flip', params.display.windowPtr);
        WaitSecs(1/15); % release CPU time

    Screen('LoadNormalizedGammaTable', params.display.screenNumber,cmap(:,:,round(rand(1))+1));
    HideCursor;

    
    % ready 
    sound(sin(1:100));
    KbCheck;
    
    % go
%    Screen('DrawTexture', params.display.windowPtr, stimulus.textures(1), stimulus.srcRect, stimulus.destRect);
    cmapNumber = 1;
    while(1),
        % scan the keyboard for experimentor input
        [exKeyIsDown,exSecs,exKeyCode] = KbCheck(params.display.devices.keyInputInternal);
        if(exKeyIsDown)
            if(exKeyCode(key.end)),
                quitProg = true;
                break; % out of while loop
            else
                if cmapNumber==1, 
                    cmapNumber=2;
                else
                    cmapNumber=1;
                end
                sound(sin(1:100));
                Screen('LoadNormalizedGammaTable', params.display.screenNumber,cmap(:,:,cmapNumber));
            end                               
        end
        
        % light
        
        for n=1:60
            Screen('FillRect', params.display.windowPtr, freq(n));
            Screen('Flip', params.display.windowPtr);
        end
    end;
    
    fprintf(1,'%%---------------------------------\n');
    fprintf(1,'[%s]: LMS direction is [%.1f %.1f %.1f]\n',mfilename,cmapDir(cmapNumber,:));
    fprintf(1,'%%---------------------------------\n');

    % Close the one on-screen and many off-screen windows
    closeScreen(params.display);

catch
    % clean up if error occurred
    Screen('CloseAll');     
    setGamma(0);
    ShowCursor;
    rethrow(lasterror);
end;

Screen('Preference', 'Verbosity', oldLevel);
