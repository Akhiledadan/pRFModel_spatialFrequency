"""
-----------------------------------------------------------------------------------------
convert2niigz.py
-----------------------------------------------------------------------------------------
Goal of the script:
Convert PAR/REC to nifti (nii.gz) format
-----------------------------------------------------------------------------------------
Input(s):
sys.argv[1]: raw data directory
sys/argv[2]: name of converter to use (parrec2nii or dcm2niix)
-----------------------------------------------------------------------------------------
Output(s):
nifti files
-----------------------------------------------------------------------------------------
To run:
ssh -Y compute-01
module load collections/default
cd /data1/projects/fMRI-course/Spinoza_Course/
python convert2niigz.py [your raw data path] [dcm2niix or parrec2nii]
-----------------------------------------------------------------------------------------
Written by Martin Szinte (martin.szinte@gmail.com)
-----------------------------------------------------------------------------------------
"""

# imports modules
import sys
import os
import glob
import nibabel as nb
opj = os.path.join

# define subject folder
input_folder = sys.argv[1]
convert_name = sys.argv[2]

# create output folder
# output_folder = opj(input_folder,'nifti')
output_folder = opj(input_folder)
try: os.makedirs(output_folder)
except: pass

# get PAR REC file list
list_par_files = glob.glob(opj(input_folder,'*.PAR'))

# convert files
print('convert files to nifti')

# using dcm2niix
if convert_name == 'dcm2niix':
	cmd_txt = "{converter} -b n -o {out} -z y {in_folder} ".format(converter = convert_name, out = output_folder, in_folder = input_folder)
	os.system(cmd_txt)

# using parrec2nii
elif convert_name == 'parrec2nii':
	for par_file in list_par_files:
		print(par_file)
		cmd_txt = "{converter} --compressed -c --overwrite --store-header -o {out} {par}".format(converter = convert_name, out = output_folder, par = par_file)
		os.system(cmd_txt)

	# separate b0 magnitude and phasediff files
	b0_file = glob.glob(opj(output_folder,'*B0*'))
	b0_load = nb.load(b0_file[0])

	b0_data = b0_load.get_data()
	for typeB0num, typeB0 in enumerate(['magnitude','phasediff']):
		out_img = nb.Nifti1Image(dataobj = b0_data[...,typeB0num], affine = b0_load.affine, header = b0_load.header)
		out_img.to_filename(b0_file[0][:-7]+"_{}.nii.gz".format(typeB0))
