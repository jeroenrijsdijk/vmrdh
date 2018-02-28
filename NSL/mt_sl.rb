# OmniTRANS Job for 'VMRDH1_NSL2018'
# Created 28-2-2018 15:35:16
#
# calc a new 2017 matrix for NSL
#
# jri 02/2018
#
#
#

#####################
# pmturi's for AUTO and VRACHT
#####################
mats=[[1,3,1,3],[1,3,2,3],[1,3,3,3],[1,2,1,103],[1,2,2,101],[1,2,3,103]]
slmats=[  
[1,3,1,41, 1, 1, 378,2 ], \
[1,3,2,41, 1, 1, 378,2 ], \
[1,3,3,41, 1, 1, 378,2 ], \
[1,2,1,41,11,20, 378,2 ], \
[1,2,2,41,11,20, 378,2 ], \
[1,2,3,41,11,20, 378,2 ]]

#####################
# open the cubes
#####################
mc=OtMatrixcube.open("2017_SMC")
ms=OtSelectedLinkCube.open("")


#####################
# open the new cube, or create it
#####################
begin
  mcn=OtMatrixcube.open("2017_SMC_MT")
rescue
  mcn=OtMatrixcube.create("2017_SMC_MT")
end

#####################
# New matrix 
#####################
mats.each_index {  |i|
  smc=mc[*mats[i]]   # Get the matrix
  slm=ms[*slmats[i]] # Get the selected link matrix
  smc=smc-slm*0.5    # now substract half of the Selected Link Matrix
  msn[*mats[i]]=smc   # put it into the new cube
}
