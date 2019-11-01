function retroicorPredictor( params )

fid = fopen( params.filename );

tline = fgetl(fid);
counter = 0;
counterStore = 0;
storeFlag = 0;
outMat = [];
while ischar(tline)
    tline = fgetl(fid);
    counter = counter + 1;
    if counter > 6 && ischar(tline)
        
        arrayLine = cell2mat( textscan( tline, '%d %d %d %d %d %d %d %d %d %d' ) );
        
        if ~isempty( arrayLine )
            
            if ( arrayLine( 10 ) == 10 ) && ( storeFlag == 0 )
                storeFlag = 1;
            end
            
            if ( arrayLine( 10 ) == 20 )
                storeFlag = 0;
            end
            
            if ( storeFlag == 1 )
                counterStore = counterStore + 1;
                outMat( counterStore, : ) = [ arrayLine( [ 5 6 ] ), counter ];
            end
                        
        end
        
    end
end

fclose(fid);

sequenceLength = params.sequenceLenght;
dt = params.resamplingSeries;

xAcquiredStep =  sequenceLength ./ max( ( outMat(:,3) - outMat(1,3) ) ) ;
xAcquired = ( outMat(:,3) - outMat(1,3) ) .* xAcquiredStep ;
respAcquired = outMat(:,2)';
pulseAcquired = outMat(:,1)';

xInterpolate = [ 0 : dt : sequenceLength-dt ];
respInterp = interp1( xAcquired, respAcquired, xInterpolate );
pulseInterp = interp1( xAcquired, pulseAcquired, xInterpolate );

plot( xInterpolate, pulseInterp )

dlmwrite( 'respData.dat', respInterp, 'delimiter', '\t', ...
         'precision', 6 ) 
dlmwrite( 'pulseData.dat', pulseInterp, 'delimiter', '\t', ...
         'precision', 6 )

Opt.Respfile = 'respData.dat';
Opt.Cardfile = 'pulseData.dat';
Opt.VolTR = params.tr;
Opt.Nslices = params.nSlices;
Opt.PhysFS = 1./dt;
Opt.SliceOrder = params.sliceOrder;
Opt.Demo = 0;
Opt.Prefix = params.fileOutput;
Opt.RVT_out = params.RVT_out;

RetroTS(Opt);  
