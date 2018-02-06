# OmniTRANS Job 
# =========================================================================================
# schrijft tekstfiles met reistijden
# het script gaat er van uit dat de skims al gedraaid zijn
# =========================================================================================

writeln "Dump reistijden Fiets naar text-file voor qgis"
writeln "Join deze met een Centroidsbestand, en maak dan Contouren met de Contour plugin"


# VMRDH1
$nzones=7786

# voor het gemak
def f(value)
  sprintf('%05.3f', value)
end

skimmat=OtSkimCube.open()


# willekeurige herkomst zones waarvoor we bestanden willen maken
# voor deze zones worden een reistijden bestand gemaakt
aantalzonesh=[6180,6257,5333,6567]   

# alle bestemmingen
aantalzonesb=[1..$nzones].unreduce


t=2 #  reken alleen voor de restdag

todomats= [[P_Totaal,M_Fiets,t,U_Totaal,2,1],[P_Totaal,M_Fiets,t,U_Totaal,3,1],[P_Totaal,M_Fiets,t,U_Totaal,2,3],[P_Totaal,M_Fiets,t,U_Totaal,3,3]]  #tijd
# 1..5 = cost,distance,time,turns,userAttribute

writeln "* writing files..."
todomats.each { |pmturi| 
    skm=skimmat[*pmturi]  #splash operator 

    for i in aantalzonesh
      filenaam="D:\\skimdump_"+$Ot.variant+"-H"+i.to_s+pmturi.join("-") +'.csv'
      unit1 = File.new(filenaam,'w+')	

      for j in aantalzonesb
        unit1.print i ,";",j,";",	f(skm[i,j]), "\n"
      end #j
      #unit1.print "\n"
      unit1.close
    end #i
    
    #unit1.close
}

writeln "Einde script"
