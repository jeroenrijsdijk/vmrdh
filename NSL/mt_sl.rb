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
slmats41=[  
[1,3,1,41,10,1], \
[1,3,2,41,10,1], \
[1,3,3,41,10,1], \
[1,2,1,41,11,20], \
[1,2,2,41,11,20], \
[1,2,3,41,11,20]]

slmats42=[  
[1,3,1,42,10,1], \
[1,3,2,42,10,1], \
[1,3,3,42,10,1], \
[1,2,1,42,11,20], \
[1,2,2,42,11,20], \
[1,2,3,42,11,20]]

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
  
  smc  =mc[*mats[i]]   # is the smc matrix
  
  slm41=ms[*slmats41[i]] # is the selected link matrix    #o/1 matrix
  slm42=ms[*slmats42[i]] # is the selected link matrix    #o/1 matrix
  
  
  
  #mc  is 2017_cms matrix
  
  mt41mat= smc.multiply(slm41)
  er42mat= smc.multiply(slm42)
  
  writeln("MT ",mt41mat.sum)
  writeln("Er ",er42mat.sum)
  
  # substract half of the Selected Link Matrix
  # then put it into the new cube  
  
  smcn= smc- mt41mat.multiply!(0.20)- er42mat.multiply!(0.05)
  
  mcn[*mats[i]]= smcn
}

print "Einde script.\n"

