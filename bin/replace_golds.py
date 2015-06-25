#!/usr/bin/env python


# Tool for pulling down gold folders from another folder

import os, sys


# Change this to copy from somewhere else!
REMOTE_FOLDER = '/home/oalexan1/projects/StereoPipelineTest/'

# Enter all the folders to update here
TEST_LIST = """ssDG_alignNone_seedMode3_mapProj1_subPix1_badDisp1
ss_bundle_adjust_aerial_ceres
ssPinHole_alignHom_seedMode1_mapProj0_subPix1_parallel1
ss_point2dem_csv_proj4
ssISIS_alignHom_seedMode1_mapProj0_subPix1_optThresh
ssRPC_alignHom_seedMode1_mapProj0_subPix1_BasaltHills
ssDG_alignHom_seedMode1_mapProj0_subPix1
ssNadirPinHole_alignHom_seedMode1_mapProj0_subPix1
ssPinHole_alignHom_seedMode1_mapProj0_subPix1
ss_isis_mapproject_moc
ssISIS_alignHom_seedMode1_mapProj0_subPix1_crop_left_right
ssISIS_alignHom_seedMode1_mapProj0_subPix1_parallel"""
TEST_LIST = TEST_LIST.split()



# Get a list of all the contents of the test folder
THIS_FOLDER    = os.path.dirname(os.path.abspath(__file__))
TEST_FOLDER    = os.path.join(THIS_FOLDER, '..')


for f in TEST_LIST:

    # Get paths
    testFolder  = os.path.join(TEST_FOLDER, f)
    goldFolder  = os.path.join(testFolder, 'gold')
    testFolderR = os.path.join(REMOTE_FOLDER, f)
    goldFolderR = os.path.join(testFolderR, 'gold')

    # Copy the folder
    cmd = 'cp -r ' + goldFolderR +' '+ goldFolder
    print cmd
    os.system(cmd)

    






