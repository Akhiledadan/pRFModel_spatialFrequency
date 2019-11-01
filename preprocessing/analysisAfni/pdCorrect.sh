#!/bin/bash

MPRAGE=$1
PD=$2

3dcalc -a $MPRAGE -b $PD -expr 'a / ( b*ispositive(a) )' -prefix MPRAGE_PD+orig

3dAFNItoNIFTI MPRAGE_PD+orig

rm *.BRIK

rm *.HEAD
