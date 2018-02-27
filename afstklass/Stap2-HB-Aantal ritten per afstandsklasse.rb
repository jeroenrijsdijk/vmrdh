writeln "Berekenen aantal ritten per afstandsklasse\n"

#job berekent aantal verplaatsingen per afstandsklasse
#benodigd is uiteraard een skimmatrix met afstanden voor de gewenste vervoerwijze


begin
  # ----------------------------------------------------------------------------------------------------------
    # de writeln wordt standaard uitgebreid door deze method met
    # de actuale tijd, dit scheelt weer handmatig in de job overal
    # Time.now te gebruiken. (technisch: deze moet buiten de module
    # zelf staan!)
    # ----------------------------------------------------------------------------------------------------------
    alias xwriteln writeln
    def writeln(*param)
      xwriteln "[#{Time.now.strftime('%H:%M:%S')}]  ",*param
    end
end



zonebegin = 1
zoneeind = 5791
zonestodo= zonebegin..zoneeind

#defineer afstandsklassen
#apart voor personenauto en vrachtauto
km_pa = [0.0, 3.0, 5.0, 15.0, 9999999.9]
#km_pa = [0.0, 3.0, 15.0, 9999999.9]
#km_vr = [0.0, 3.0, 5.0, 15.0, 9999999.9]
#km_vr = [0.0, 3.0, 15.0, 9999999.9]

writeln "Klassen Auto   ", km_pa.join(";")
#writeln "Klassen Vracht ", km_vr.join(";")

#openen verplaatsing- en afstanden matrices
mc1 = OtMatrixCube.open

begin
 sm = OtSkimCube.open
rescue
 raise "This script desperately needs skims. Generate them first"
end

[2].each { |m| 
[1,2,3].each { |t| 

  print "berekening Restdag, " if t==1
  print "berekening OS, " if t==2
  print "berekening AS, " if t==3
  
  print "Vracht Licht." if m==31
  print "Vracht zwaar." if m==32

  print "\n"
 
  if m==2 
    u=103
    u=101 if t==1  
    i=20
    r=16    
  else
    u=3
    i=1
    r=15
  end


  #
  distance=2
  #

  pmtu=[1,m,t,u]
  #pmturi=[1,m,t,u,distance,i] 
  pmturi=[1,2,1,101,1,1]   
    
  pa    = mc1[*pmtu]     # matrix 
  sm_pa =  sm[*pmturi]   # skim

  # ga zones langs
  # als aftand is tussen km_pa[0] en km_pa[1]
  #   vul dan de matrix

  aantal_auto = km_pa.length

  (0..(aantal_auto-2)).each { |klasse|   # loop moet later weg!
  
    low  = km_pa[klasse]
    high = km_pa[(klasse+1)]
    
    dezeklasse= OtMatrix.new(5791)  #nieuwe matrix met nullen
    dezeklasse[]=0
    
    writeln "* ",klasse,": Klasse ", low, " tot ", high
    zonestodo.each { |h|
      zonestodo.each { |b|
        if (sm_pa[h,b]>=low) && (sm_pa[h,b]<high)
          dezeklasse.set(h,b, pa[h,b])
        end      
      } #zonestodo
    } #zonestodo
    
    writeln "* Schrijf matrix ", klasse
    mc1[1,m,t,klasse+80]= dezeklasse    
  }

  writeln "* Check voor t=",t
  som1=0
  (0..(aantal_auto-2)).each { |klasse|   
      writeln "Som ",klasse,"=", mc1[1,m,t,klasse+80].sum
      som1=som1+mc1[1,m,t,klasse+80].sum
  }
  writeln "Som delen is ", som1
  writeln "Som origineel is ", mc1[1,m,t,u].sum
  writeln "Verschil is ", (som1-mc1[1,m,t,u].sum).round #6 decimalen float
  
}
}
writeln "klaar met de berekeningen"


