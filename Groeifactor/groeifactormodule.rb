
#########################################################
# JRI voor v-mrdh 1.0 en later (Omnitrans)
# 
# OtGrowthfactor -  script voor ophoging Aankomsten en Vertrekken via Fratar
#
# let op CONCEPT, NOG NIET GETEST!
#
#########################################################



def iter(pmtu, todocols, todorows)
  ################################
  # DEZE FUNCTIE DOET 1 OPHOGING #
  ################################

  puts("Open Matrices... ")
  my_matrix_cube = OtMatrixCube.new('2016_SMC')

  # maak of open de nieuwe, opgehoogde matrix
  begin
    my_newmatrix_cube = OtMatrixCube.create('smc2016kopie')
  rescue
    my_newmatrix_cube = OtMatrixCube.open('smc2016kopie')
  end  
  

  puts("Init...")
  #my_old_matrix1 = my_matrix_cube[*pmtu]

  #inititaliseer de Groeifactor methode
  my_run1 = OtGrowthFactor.new
  my_run1.iterations = 20

  cols1 = my_matrix_cube[*pmtu].colTotals
  rows1 = my_matrix_cube[*pmtu].rowTotals

  todocols.each { |a| 
    cols1[a[0]] = a[1]
  }

  todorows.each { |a| 
    rows1[a[0]] = a[1]
  }

  puts("Run...")
  my_newmatrix_cube[*pmtu] = my_run1.execute(my_matrix_cube[*pmtu], rows1, cols1)
  
  writeln("Matrix [", pmtu.join(","), "] aangepast.")
end


# START #

# Dit zijn de PMTURIs van de matrices in VMRDH10
AutoOS = [1,2,1,103]
AutoRD = [1,2,2,101]
AutoAS = [1,2,3,103]
VrOS   = [1,3,1,1]
VrRD   = [1,3,2,1]
VrAS   = [1,3,3,1]


# Voorbeeld: 
#
#  aanroepen met  'iter(pmturi_matrix,  nieuwe kolomtotalen, nieuwe rijtotalen)'
#
#   result = iter(AutoOS, [[134, 123], .. ], [[134, 234], .. ]
#
# In zone 134, mode=Auto, tijd=ochtendspits 
#   123 auto's komen aan (aankomsten, coltotal), en 
#   234 auto's gaan weg (vertrekken, rowtotals). 
#
r = iter(AutoOS, [[134, 123],[135, 456],[136, 789]], [[134, 234],[135, 456],[136, 789]])

r = iter(AutoRD, [[134, 123],[135, 456],[136, 789]], [[134, 123],[135, 456],[136, 789]])
r = iter(AutoAS, [[134, 123],[135, 456],[136, 789]], [[134, 123],[135, 456],[136, 789]])
r = iter(VrOS  , [[134,  12],[135, 45 ],[136, 78 ]], [[134,  12],[135, 45 ],[136, 78 ]])
r = iter(VrRD  , [[134,  12],[135, 45 ],[136, 78 ]], [[134,  12],[135, 45 ],[136, 78 ]])
r = iter(VrAS  , [[134,  12],[135, 45 ],[136, 78 ]], [[134,  12],[135, 45 ],[136, 78 ]])

writeln "Klaar."



