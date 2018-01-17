

# JRI 2/8/2017 dump hb matrix RVMK3
# JRI update 18-01-2018 voor VMRDH1 / RVMK4
# 
# dit script schrijft herkomst en bestemming centroid met aantal ritten
# auto, vracht, openbaar vervoer, fiets
#
#
# RVMK3 
# $nzones=5791

# VMRDH1
$nzones=7786

# voor het gemak
def f(value)
  sprintf('%09.8f', value)
end


# bestandsnaam voor output IN CSV FORMAT
tot_filen = 'd:\matrixdump2016vmrdh1'
tot_filen= tot_filen+"_" while FileTest.exist?(tot_filen+".csv")
tot_filen= tot_filen + ".csv"
f = File.new(tot_filen, 'w')
f.print "tijd,H,B,aantalpa,aantalvr,aantalov,aantalfts\n"

# matrixnummer per mode, time:
auto_rd = [1,2,1,103]
auto_os = [1,2,2,101]
auto_as = [1,2,3,103]

vracht_rd= [1,3,1,1]
vracht_os= [1,3,2,1]
vracht_as= [1,3,3,1]

ov_rd=[1,4,1,1]
ov_os=[1,4,2,1]
ov_as=[1,4,3,1]

ft_rd=[1,5,1,1]
ft_os=[1,5,2,1]
ft_as=[1,5,3,1]

# verzamel het in een 'todo' lijstje
# handig als je een keer een periode minder wilt doen
pa_mats=[auto_rd,auto_os,auto_as]
vr_mats=[vracht_rd,vracht_os,vracht_as]
ov_mats=[ov_rd,ov_os,ov_as]
ft_mats=[ft_rd,ft_os,ft_as]

# nodig voor naambepaling:
matrixcubenaam = $Ot.currentCube
writeln "The current matrix cube is ",matrixcubenaam 
writeln "Opening ",matrixcubenaam 
mc=OtMatrixCube.open(matrixcubenaam)
  
for t in [1,2,3] 
  # open matrix
  # matcompress
  
  writeln " * Open result periode ",t
  pa_matrixnummer=pa_mats[t-1]
  vr_matrixnummer=vr_mats[t-1]
  ov_matrixnummer=ov_mats[t-1]
  ft_matrixnummer=ft_mats[t-1]
  
  # niet mooi, maar de enige manier:
  pa_mat=mc[pa_matrixnummer[0],pa_matrixnummer[1],pa_matrixnummer[2],pa_matrixnummer[3]]
  #pa_cmat=pa_mat.compress(rows,cols)
  #pa_mat=nil
  #ObjectSpace.garbage_collect
  
  vr_mat=mc[vr_matrixnummer[0],vr_matrixnummer[1],vr_matrixnummer[2],vr_matrixnummer[3]]
  #vr_cmat=vr_mat.compress(rows,cols)
  #vr_mat=nil
  #ObjectSpace.garbage_collect

  
  ov_mat=mc[ov_matrixnummer[0],ov_matrixnummer[1],ov_matrixnummer[2],ov_matrixnummer[3]]
  #ov_cmat=ov_mat.compress(rows,cols)
  #ov_mat=nil
  #ObjectSpace.garbage_collect

  
  ft_mat=mc[ft_matrixnummer[0],ft_matrixnummer[1],ft_matrixnummer[2],ft_matrixnummer[3]]
  #ft_cmat=ft_mat.compress(rows,cols)
  #ft_mat=nil
  #ObjectSpace.garbage_collect

  writeln "schrijven ",$nzones," waarden"
  for i in 1..$nzones
    if i % 100==0 
      print i, "\n"
    end
    for j in 1..$nzones
        if [pa_mat[i,j],vr_mat[i,j],ov_mat[i,j],ft_mat[i,j]].sum > 0.1
          line=[]
          line << t << i << j << pa_mat[i,j] << vr_mat[i,j] << ov_mat[i,j] << ft_mat[i,j]
          f.print line.join(",")
          f.print "\n"
        end #if
    end #j
  end #i
end #t

#end #i (resultnummer)
f.close
writeln "Einde"

