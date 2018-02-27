#
#
# RVMK STADSREGIO ROTTERDAM
# TOEDELING 4 USERS 
# MUC - MULTI USER CLASS
# CODE:
# -JRI (intern-extern script), 
# -WKA (maastunnel bestelverkeer), 
# -IOE (haagse scripts)
# SEE ALSO: TOEDELEN INTERN EXTERN RVMK30
#
# DIT SCRIPT IS EEN VAN 3 SCRIPTS 
# -> gaat uit van 4 u's , userklassen 80..83.
# stap1 : maak skim
# stap2 : maak hb's per afstandsklasse (80..83)
# stap3 : dit script 


Start= Time.now
writeln "Start: ", Time.now
writeln "Inlezen parameter bestanden..."
load $Ot.dirJob+'Simjobs\parameters_rvmk3_rtd2010.rb'
include Parameters_rtd

#CONSTANTS
threads                         = 8

#=====================================
toedelenVracht		    		      = false
toedelenAutoSpits	    		      = true
toedelenAutoRdVa	    		      = true
#=====================================


  
if toedelenVracht
  writeln "   * vrachtautoverkeer middelzwaar en zwaar toedelen"
  for t in [1,2,3] 
   for m in [31,32]
    writeln "* tijd ",t," en mode ",m 
    traffic 				  	        = OtTraffic.new
    traffic.odMatrix 		  	    = [Totaal,m,t,[80,81,82,83]] 
    traffic.network		  	      = [Vracht,t]
    traffic.load 			  	      = [Totaal,m,t,[80,81,82,83],Aon,1] 
    traffic.routeFactors 		  	= [VrachtCostAfstand,VrachtCostTijd,0,0]
    traffic.numberOfThreads	  	= threads
    traffic.execute
   end
   
  writeln "   * vrachtloads bewerken voor t=",t
  network = OtNetwork.new
  
  # maakt vracht = 3 door 31 en 32 op te tellen voor de 4 klassen
  # dat moet vanwege preloads!!
  (80..83).each { |klasse|
     network.updateResults([Totaal,Middelzwaar,t,klasse,Aon,1],[Totaal,Zwaar,t,klasse,Aon,1],[Totaal,Vracht,t,klasse,Aon,1],1.0,1.0)
  }
  
  # pae moet vanwege preloads:  
  # begin met 80, en tel 81..83 erbij op
  network.copyLoad([Totaal,Vracht,t,80,Aon,1],[Totaal,Vracht,t,Usercat,Aon,1],1.0)
  network.updateResults([Totaal,Vracht,t,Usercat,Aon,1],[Totaal,Vracht,t,81,Aon,1],[Totaal,Vracht,t,Usercat,Aon,1],1.0,1.0)
  network.updateResults([Totaal,Vracht,t,Usercat,Aon,1],[Totaal,Vracht,t,82,Aon,1],[Totaal,Vracht,t,Usercat,Aon,1],1.0,1.0)
  network.updateResults([Totaal,Vracht,t,Usercat,Aon,1],[Totaal,Vracht,t,83,Aon,1],[Totaal,Vracht,t,Usercat,Aon,1],1.0,1.0)
  
  #en pae:
  network.copyLoad([Totaal,Vracht,t,Usercat,Aon,1],[Totaal,Vracht,t,Usercat,Pae,1],2.0)

  end #t
end

# CONTROLE jri 14-12-2014
# dit toedeelscript levert tot hier de goede vrachttotalen op 
# voor m=31,32 en m=3 (Usercat user=3)
#  [1,3,t,3,15,1] !=  [1,[31,32],t,3,[80..83],1]
# let op de eerste m=3. 
#
# ook de oorspronkelijke vracht toedeling uit het basismodel
# wordt perfect gereproduceerd!
#




if toedelenAutoSpits
   for t in [2,3]
    writeln "   * personenautoverkeer spitsperioden toedelen t=",t
    traffic				   	          = OtTraffic.new
    traffic.assignMethod		   	= VOLUMEAVERAGING
    traffic.iterations		   	  = 20
    traffic.junctions 		   	  = true
    traffic.junctionParameters 	= [0.5,1.0]
    #traffic.modelVersion        = 14  
    traffic.junctionVersion 	  = 25
    traffic.epsilon			   	    = 0.00000001
    traffic.functionType		   	= [19,19,19,19]    #4x!
    
    bpr = [[[1..14,71..73],[0.5,4.0]], \
				  [[20,21,23,25,62,68..70,74,75],[1.0,4.0]], \
				  [[22,24,26..28,35..39,42,63,65],[1.5,4.0]], \
				  [[40,41,64,66],[2.0,4.0]], \
				  [[51,67],[4.0,4.0]], \
				  [[52,53,55..58],[0.0,4.0]]]
    traffic.bprPerType=[bpr,bpr,bpr,bpr]
    
    traffic.network			        = [[Auto,t],[Auto,t],[Auto,t],[Auto,t]] #4x (mode), of 1x (4x user, 1 mode!)? 
    traffic.routeFactors 			  = [[AutoCostAfstand,AutoCostTijd,0,0], [AutoCostAfstand,AutoCostTijd,0,0], [AutoCostAfstand,AutoCostTijd,0,0], [AutoCostAfstand,AutoCostTijd,0,0]]
    # traffic.odMatrix			      = [Totaal,Auto,t,[80,81,82,83]]
    traffic.odMatrix			      = [[Totaal,Auto,t,80],[Totaal,Auto,t,81],[Totaal,Auto,t,82],[Totaal,Auto,t,83]]
    # traffic.load				        = [Totaal,Auto,t,[80,81,82,83],Va,20]
    traffic.load				        = [[Totaal,Auto,t,80,Va,20],[Totaal,Auto,t,81,Va,20],[Totaal,Auto,t,82,Va,20],[Totaal,Auto,t,83,Va,20]]
    traffic.preLoad             = [Totaal,Vracht,t,Usercat,Pae,1]
    traffic.numberOfThreads	    = threads
    traffic.execute
   end
 end
 

# Test geslaagd!! toegedeelde 80..83 komt overeen met auto spitsen!!




if toedelenAutoRdVa   # duurt twee uur op laptop
    writeln "   * personenautoverkeer dalperiode toedelen"
    traffic					            = OtTraffic.new
    traffic.assignMethod			  = VOLUMEAVERAGING
    traffic.iterations 			    = 20 
    traffic.junctions 			    = true
    traffic.junctionParameters 	= [0.5,1.0]
    traffic.modelVersion        = 14  
    traffic.junctionVersion 	  = 25
    traffic.epsilon				      = 0.00000001
    traffic.functionType			  = [19,19,19,19]
    bpr = [[[1..14,71..73],[0.5,4.0]], \
				  [[20,21,23,25,62,68..70,74,75],[1.0,4.0]], \
				  [[22,24,26..28,35..39,42,63,65],[1.5,4.0]], \
				  [[40,41,64,66],[2.0,4.0]], \
				  [[51,67],[4.0,4.0]], \
				  [[52,53,55..58],[0.0,4.0]]]
    traffic.bprPerType=[bpr,bpr,bpr,bpr]
    traffic.network			        = [[Auto,Restdag],[Auto,Restdag],[Auto,Restdag],[Auto,Restdag]]
    traffic.routeFactors 			  = [[AutoCostAfstand,AutoCostTijd],[AutoCostAfstand,AutoCostTijd],[AutoCostAfstand,AutoCostTijd],[AutoCostAfstand,AutoCostTijd]]      
    traffic.odMatrix			      = [[Totaal,Auto,Restdag,80],[Totaal,Auto,Restdag,81],[Totaal,Auto,Restdag,82],[Totaal,Auto,Restdag,83]]
    traffic.pcuFactor 			    = [1.0/RD_factor_auto,1.0/RD_factor_auto,1.0/RD_factor_auto,1.0/RD_factor_auto]
    traffic.load				        = [[Totaal,Auto,Restdag,80,Va,20],[Totaal,Auto,Restdag,81,Va,20],[Totaal,Auto,Restdag,82,Va,20],[Totaal,Auto,Restdag,83,Va,20]]
    traffic.preLoad             = [[[Totaal,Vracht,Restdag,3,Pae,1],(1.0/RD_factor_vracht)]]
    traffic.numberOfThreads	    = threads
    traffic.execute
    
    
		writeln "bewerken loads restdag autoverkeer (ophogen naar totaal restdag en verwijderen tussenload (nr 141)"	
    writeln "   * autoloads restdag bewerken"
    network = OtNetwork.new
    #network.copyLoad([Totaal,Auto,Restdag,141,Va,20],[Totaal,Auto,Restdag,101,Va,20],RD_factor_auto/1.0)


network.factorResults([Totaal,Auto,Restdag,80,Va,20],RD_factor_auto/1.0)
network.factorResults([Totaal,Auto,Restdag,81,Va,20],RD_factor_auto/1.0)
network.factorResults([Totaal,Auto,Restdag,82,Va,20],RD_factor_auto/1.0)
network.factorResults([Totaal,Auto,Restdag,83,Va,20],RD_factor_auto/1.0)
    #network.copyLoad([Totaal,Auto,Restdag,80,Va,20],[Totaal,Auto,Restdag,80,Va,20],RD_factor_auto/1.0)
    #network.copyLoad([Totaal,Auto,Restdag,81,Va,20],[Totaal,Auto,Restdag,81,Va,20],RD_factor_auto/1.0)
    #network.copyLoad([Totaal,Auto,Restdag,82,Va,20],[Totaal,Auto,Restdag,82,Va,20],RD_factor_auto/1.0)
    #network.copyLoad([Totaal,Auto,Restdag,83,Va,20],[Totaal,Auto,Restdag,83,Va,20],RD_factor_auto/1.0)
    #network.deleteResults([Totaal,Auto,Restdag,141,Va,20])
    #network.copyLoad([Totaal,Auto,Restdag,142,Va,20],[Totaal,Auto,Restdag,104,Va,20],RD_factor_auto/1.0)
    #network.deleteResults([Totaal,Auto,Restdag,142,Va,20])
end

writeln Time.now
writeln "Einde. Duur run: ", Start-Time.now


