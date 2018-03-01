##############################################
# MATRIX INTERPOLATIE 2016 - > 2023
#
# TUSSENLIGGENDE JAREN VMRDH1.0 
#  VIA LINEARE INTERPOLATIE
##############################################

writeln "matrix interpolatie"

# open de matrixcubes van 2016 en 2023
mc16 = OtMatrixCube.open("2016_SMC")
mc23 = OtMatrixCube.open("2023_SMC")

begin 
  mc20 = OtMatrixCube.create("2020_SMC")
rescue
  mc20 = OtMatrixCube.open("2020_SMC")
end



# 2020 ligt op   */7 van de periode 2016-2023
# daarom */7 van het verschil tussen '16 en '23 
factor = 1-((2023-2020)/(2023-2016))  

##############################################
# Auto
##############################################

writeln "Auto..."

am1=mc16.get([1,2,1,103])  #auto, os
am2=mc16.get([1,2,2,101])  #auto, rd
am3=mc16.get([1,2,3,103])  #auto, as

bm1=mc23.get([1,2,1,103])
bm2=mc23.get([1,2,2,101])
bm3=mc23.get([1,2,3,103])

mc20[1,2,1,103]= am1+ (bm1-am1)*factor
mc20[1,2,2,101]= am2+ (bm2-am2)*factor
mc20[1,2,3,103]= am3+ (bm3-am3)*factor

##############################################
# Vracht
##############################################

writeln "Vracht..."

am1=mc16.get([1,3,1,1])
am2=mc16.get([1,3,2,1])
am3=mc16.get([1,3,3,1])

bm1=mc23.get([1,3,1,1])
bm2=mc23.get([1,3,2,1])
bm3=mc23.get([1,3,3,1])

mc20[1,3,1,1]= am1+ (bm1-am1)*factor
mc20[1,3,2,1]= am2+ (bm2-am2)*factor
mc20[1,3,3,1]= am3+ (bm3-am3)*factor



##############################################
# PT
##############################################

writeln "Openbaar Vervoer..."

am1=mc16.get([1,4,1,1])
am2=mc16.get([1,4,2,1])
am3=mc16.get([1,4,3,1])

bm1=mc23.get([1,4,1,1])
bm2=mc23.get([1,4,2,1])
bm3=mc23.get([1,4,3,1])

mc20[1,4,1,1]= am1+ (bm1-am1)*factor
mc20[1,4,2,1]= am2+ (bm2-am2)*factor
mc20[1,4,3,1]= am3+ (bm3-am3)*factor

[83,84,85,86].each { |u|

  am1=mc16.get([1,4,1,u])
  am2=mc16.get([1,4,2,u])
  am3=mc16.get([1,4,3,u])

  bm1=mc23.get([1,4,1,u])
  bm2=mc23.get([1,4,2,u])
  bm3=mc23.get([1,4,3,u])

  mc20[1,4,1,u]= am1+ (bm1-am1)*factor
  mc20[1,4,2,u]= am2+ (bm2-am2)*factor
  mc20[1,4,3,u]= am3+ (bm3-am3)*factor

}

##############################################
# FIETS
##############################################

writeln "PT..."

am1=mc16.get([1,5,1,1])
am2=mc16.get([1,5,2,1])
am3=mc16.get([1,5,3,1])

bm1=mc23.get([1,5,1,1])
bm2=mc23.get([1,5,2,1])
bm3=mc23.get([1,5,3,1])

mc20[1,5,1,1]= am1+ (bm1-am1)*factor
mc20[1,5,2,1]= am2+ (bm2-am2)*factor
mc20[1,5,3,1]= am3+ (bm3-am3)*factor

writeln "klaar."

