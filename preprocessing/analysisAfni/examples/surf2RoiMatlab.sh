#!/bin/bash
myNum=30
myNum2=50
myT="Demo\ of\ Peaks\(${myNum}\)"
myPNG="fig_peaks_${myNum}"
myName=$AFNI_MATLAB
#eval "matlab -nodesktop -nosplash -r showPeaks\(${myNum},\'${myT}\',\'${myPNG}\'\)"
funName=$(printf '%s/examples/showPeaks' $AFNI_TOOLBOXDIR)
echo $funName
#eval "matlab -nodesktop -nosplash -r $funName\(${myNum},\'${myT}\',\'${myPNG}\',\'${myName}\',${myNum2}\)"

matlab -nodesktop -nosplash -r "$funName ${myNum} ${myT} ${myPNG} ${myName} ${myNum2}"
