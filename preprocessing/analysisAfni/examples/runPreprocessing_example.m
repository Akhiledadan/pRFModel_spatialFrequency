clear all
close all

myStartup('+','matFileAddOn')
myStartup('+','afni_matlab')
automaskControlThr = 0.4;
phaseDir = 'PHASE';

PATH = getenv('PATH');
setenv( 'PATH', [PATH ':/usr/lib/afni/bin'] );
setenv( 'PATH', [PATH ':/home/alessiofracasso/Dropbox/analysisAfni/'] );

system('rm anatomy/meanEpi.nii')
system('rm anatomy/*_scaled.nii')
system('rm anatomy/phaseAnatomy.nii')
system('rm anatomy/amplitudeAnatomy.nii')
system('rm anatomy/meanTs.nii')
system('rm PHASE/*.BRIK')
system('rm PHASE/*.HEAD')
system('rm PHASE/*.1D')
system('rm PHASE/*_unwrap.nii')
system('rm -R motionCorrect.results')
system('rm output.proc.motionCorrect')
system('rm proc.motionCorrect')

system('. motionCorrect.afni')
system('tcsh -xef proc.motionCorrect |& tee output.proc.motionCorrect')

cd motionCorrect.results/
volregFiles = dir('*volreg+orig.BRIK');
meanVolregSingleFileCommand = sprintf('3dTstat -prefix meanForAutomask+orig %s', volregFiles(1).name );
automaskCommand = sprintf('3dAutomask -prefix brainMask+orig -clfrac %1.1f meanForAutomask+orig', automaskControlThr);
system( meanVolregSingleFileCommand )
system( automaskCommand )
system( 'rm meanForAutomask+orig.BRIK')
system( 'rm meanForAutomask+orig.HEAD')
cd ..

phaseAnalysis

system('. motionCorrectPhaseImages')
system('. computeAmplitudeAnatomy')

scaleAmplitudePhase

system('. computeSWIImage')
system('. computeMeanTs')

