

##############################################
### IN PROGRESS !!!!!1!!!11!!!!
##############################################

writeln "matrix interpolatie"

mc16 = OtMatrixCube.open("")
mc23 = OtMatrixCube.open("")

# kies tussen Create op Open
mc18 = OtMatrixCube.create("")
mc18 = OtMatrixCube.open("")

factor = 1-((2023-2018)/(2023-2016))  # 2018 ligt op   2/7 van de periode 2016-2023

##############################################
# Auto
##############################################

writeln "Auto..."

am1=mc16.get([1,2,1,101])
am2=mc16.get([1,2,2,103])
am3=mc16.get([1,2,3,103])

bm1=mc23.get([1,2,1,101])
bm2=mc23.get([1,2,2,103])
bm3=mc23.get([1,2,3,103])

mc18[1,2,1,101]= am1+ (bm1-am1)*factor
mc18[1,2,2,103]= am2+ (bm2-am2)*factor
mc18[1,2,3,103]= am3+ (bm3-am3)*factor

##############################################
# Vracht
##############################################

writeln "Vracht..."

am1=mc16.get([1,3,1,3])
am2=mc16.get([1,3,2,3])
am3=mc16.get([1,3,3,3])

bm1=mc23.get([1,3,1,3])
bm2=mc23.get([1,3,2,3])
bm3=mc23.get([1,3,3,3])

mc18[1,3,1,3]= am1+ (bm1-am1)*factor
mc18[1,3,2,3]= am2+ (bm2-am2)*factor
mc18[1,3,3,3]= am3+ (bm3-am3)*factor



##############################################
# PT
##############################################

writeln "PT..."

am1=mc16.get([1,4,1,3])
am2=mc16.get([1,4,2,3])
am3=mc16.get([1,4,3,3])

bm1=mc23.get([1,4,1,3])
bm2=mc23.get([1,4,2,3])
bm3=mc23.get([1,4,3,3])

mc18[1,4,1,3]= am1+ (bm1-am1)*factor
mc18[1,4,2,3]= am2+ (bm2-am2)*factor
mc18[1,4,3,3]= am3+ (bm3-am3)*factor

##############################################
# FIETS
##############################################

writeln "PT..."

am1=mc16.get([1,5,1,3])
am2=mc16.get([1,5,2,3])
am3=mc16.get([1,5,3,3])

bm1=mc23.get([1,5,1,3])
bm2=mc23.get([1,5,2,3])
bm3=mc23.get([1,5,3,3])

mc18[1,5,1,3]= am1+ (bm1-am1)*factor
mc18[1,5,2,3]= am2+ (bm2-am2)*factor
mc18[1,5,3,3]= am3+ (bm3-am3)*factor



writeln "klaar"

