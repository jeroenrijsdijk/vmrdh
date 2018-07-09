##############################################
# MATRIX INTERPOLATIE 2023 - > 2030
#
# TUSSENLIGGENDE JAREN VMRDH1.0 
#  VIA LINEARE INTERPOLATIE
##############################################

writeln "matrix interpolatie"

# open de matrixcubes van 2023 en 2030
mc23 = OtMatrixCube.open("2023_SMC")
mc30 = OtMatrixCube.open("2030H_SMC")

# kies voor 2020 tussen Create en Open
begin 
  mc20 = OtMatrixCube.create("2028_SMC")
rescue
  mc20 = OtMatrixCube.open("2028_SMC")
end


# 202* ligt op   */7 van de periode 2023-2030
# daarom */7 van het verschil tussen '23 en '30 
factor = 1.0-((2030.0-2028.0)/(2030.0-2023.0))  

##############################################
# Auto
##############################################

writeln "Auto..."

am1=mc23.get([1,2,1,103])  #auto, os
am2=mc23.get([1,2,2,101])  #auto, rd
am3=mc23.get([1,2,3,103])  #auto, as

bm1=mc30.get([1,2,1,103])
bm2=mc30.get([1,2,2,101])
bm3=mc30.get([1,2,3,103])

mc20[1,2,1,103]= am1+ (bm1-am1)*factor
mc20[1,2,2,101]= am2+ (bm2-am2)*factor
mc20[1,2,3,103]= am3+ (bm3-am3)*factor

##############################################
# Vracht
##############################################

writeln "Vracht..."

am1=mc23.get([1,3,1,1])
am2=mc23.get([1,3,2,1])
am3=mc23.get([1,3,3,1])

bm1=mc30.get([1,3,1,1])
bm2=mc30.get([1,3,2,1])
bm3=mc30.get([1,3,3,1])

mc20[1,3,1,1]= am1+ (bm1-am1)*factor
mc20[1,3,2,1]= am2+ (bm2-am2)*factor
mc20[1,3,3,1]= am3+ (bm3-am3)*factor



##############################################
# PT
##############################################

writeln "Openbaar Vervoer..."

am1=mc23.get([1,4,1,1])
am2=mc23.get([1,4,2,1])
am3=mc23.get([1,4,3,1])

bm1=mc30.get([1,4,1,1])
bm2=mc30.get([1,4,2,1])
bm3=mc30.get([1,4,3,1])

mc20[1,4,1,1]= am1+ (bm1-am1)*factor
mc20[1,4,2,1]= am2+ (bm2-am2)*factor
mc20[1,4,3,1]= am3+ (bm3-am3)*factor

[83,84,85,86].each { |u|

  am1=mc23.get([1,4,1,u])
  am2=mc23.get([1,4,2,u])
  am3=mc23.get([1,4,3,u])

  bm1=mc30.get([1,4,1,u])
  bm2=mc30.get([1,4,2,u])
  bm3=mc30.get([1,4,3,u])

  mc20[1,4,1,u]= am1+ (bm1-am1)*factor
  mc20[1,4,2,u]= am2+ (bm2-am2)*factor
  mc20[1,4,3,u]= am3+ (bm3-am3)*factor

}


##############################################
# FIETS
##############################################

writeln "Fiets..."

am1=mc23.get([1,5,1,1])
am2=mc23.get([1,5,2,1])
am3=mc23.get([1,5,3,1])

bm1=mc30.get([1,5,1,1])
bm2=mc30.get([1,5,2,1])
bm3=mc30.get([1,5,3,1])

mc20[1,5,1,1]= am1+ (bm1-am1)*factor
mc20[1,5,2,1]= am2+ (bm2-am2)*factor
mc20[1,5,3,1]= am3+ (bm3-am3)*factor

writeln "klaar."

