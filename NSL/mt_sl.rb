# OmniTRANS Job for 'VMRDH1_NSL2018'
# Created 28-2-2018 15:35:16
#
# Calc a new 2017/2019 matrix for NSL
# Maastunnel Selected Link - [[378,2]] (Noord -> Zuid)
# Erasmusbrug Selected Link - [[14191,2]] (Noord -> Zuid)
# jri 02/2018
# jri 03/2020 correcties voor 2019 varianten (nsl 2020, over 2019).
#
# Dit script gebruikt de selectedlink matix in result 41, 42 
#    
#
#####################
# pmturi's for AUTO and VRACHT
#####################

mats=[[1,3,1,1],[1,3,2,1],[1,3,3,1],[1,2,1,103],[1,2,2,101],[1,2,3,103]] #ok 

slmats41=[  
[1,3,1,41,10,1],    
[1,3,2,41,10,1], 
[1,3,3,41,10,1], 
[1,2,1,41,11,20],    
[1,2,2,41,11,20], 
[1,2,3,41,11,20]]

slmats42=[  
[1,3,1,42,10,1], 
[1,3,2,42,10,1], 
[1,3,3,42,10,1], 
[1,2,1,42,11,20],     
[1,2,2,42,11,20], 
[1,2,3,42,11,20]]


#####################
# open the cubes
#####################
mc = OtMatrixCube.open("2019_SMC")
ms = OtSelectedLinkCube.open("2019")  # variant naar waar 0/1 mats staan


#####################
# open the new cube, or create it
#####################
begin
  mcn = OtMatrixCube.open("2019_SMC_MT")
rescue
  mcn = OtMatrixCube.create("2019_SMC_MT")
end


#####################
# New matrix voor NSL run tweede halfjaar 2017:: 
#####################
mats.each_index {  |i|
  print(*mats[i].join("-"),"\n")
  
  smc   = mc[*mats[i]]     # is the smc matrix
  
  writeln smc.sum
  
  slm41 = ms.get([*slmats41[i]],[378,2])    # MT [[378,2]]
  slm42 = ms.get([*slmats42[i]],[14191,2])  # ER [[14191,2]]

  #mc  is 2019_smc matrix
  mt41mat = smc.multiply(slm41)
  er42mat = smc.multiply(slm42)
  
  writeln mt41mat.sum
  writeln er42mat.sum

  writeln("Alle ritten in de MT mat ",mt41mat.sum)
  writeln("Alle ritten in de ER mat ",er42mat.sum)
  
  # substract a part of of the Selected Link Matrix,
  # then put it into the new cube  
  # = Vraaguitval nav sluiting tunnel
  
  smcn= smc- mt41mat.multiply!(0.20)- er42mat.multiply!(0.05)
  
  mcn[*mats[i]]= smcn
}

print "Einde script.\n"
