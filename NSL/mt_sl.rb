# OmniTRANS Job for 'VMRDH1_NSL2018'
# Created 28-2-2018 15:35:16
#
# Calc a new 2017 matrix for NSL
# Maastunnel Selected Link - 378,2 (Noord -> Zuid)
# jri 02/2018
#
# Dit script gebruikt de selectedlink matix in result 41 
#     in variant "2017"
#
#####################
# pmturi's for AUTO and VRACHT
#####################
mats=[[1,3,1,1],[1,3,2,1],[1,3,3,1],[1,2,1,103],[1,2,2,101],[1,2,3,103]]
slmats=[  
[1,3,1,41,10,1], \
[1,3,2,41,10,1], \
[1,3,3,41,10,1], \
[1,2,1,41,11,20], \
[1,2,2,41,11,20], \
[1,2,3,41,11,20]]

#####################
# open the cubes
#####################
mc=OtMatrixCube.open("2017_SMC")
ms=OtSelectedLinkCube.open("2017")


#####################
# open the new cube, or create it
#####################
begin
  mcn=OtMatrixCube.open("2017_SMC_MT")
rescue
  mcn=OtMatrixCube.create("2017_SMC_MT")
end



#####################
# New matrix voor NSL run tweede halfjaar 2017:: 
#####################
mats.each_index {  |i|
  print(*mats[i].join("-"),"\n")
  
  smc=mc[*mats[i]]   # is the smc matrix
  slm=ms[*slmats[i]] # is the selected link matrix  
  
  # substract half of the Selected Link Matrix
  # then put it into the new cube  
  smc=smc-slm.multiply!(0.5)  
  mcn[*mats[i]]= smc
}

print "Einde script.\n"
