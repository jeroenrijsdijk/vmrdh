# OmniTRANS Job for 'OT_rtd176_2'
# Created 1-10-2007 17:01:01
# =========================================================================================
  writeln "Inlezen parameter bestanden..."
# =========================================================================================
  load $Ot.dirJob+'Simjobs\parameters_rvmk3_rtd2010.rb'
  include Parameters_rtd
# =========================================================================================

toedelenVracht		= false
toedelenVracht_etm	= false
toedelenAutoSpits	= false
toedelenAutoRdVa	= false
toedelenAutoRdAon	= false
toedelenOV		= true
toedelenFiets		= false

aantalThreads	= 8	#nr of threads while 

if toedelenVracht
	writeln "   * vrachtautoverkeer"
	for t in [1,2,3] 
		for m in [31,32]
			traffic 						= OtTraffic.new
			traffic.odMatrix 				= [Totaal,m,t,Usercat]
			traffic.network					= [Vracht,t]
			traffic.load 					= [Totaal,m,t,Usercat,Aon,1] 
			traffic.routeFactors 			= [VrachtCostAfstand,VrachtCostTijd,0,0]
			traffic.numberOfThreads			= aantalThreads
			traffic.execute
		end

		writeln "   * vrachtloads bewerken"
		network = OtNetwork.new
		network.updateResults([Totaal,Middelzwaar,t,Usercat,Aon,1],[Totaal,Zwaar,t,Usercat,Aon,1],[Totaal,Vracht,t,Usercat,Aon,1],1.0,1.0)
		network.copyLoad([Totaal,Vracht,t,Usercat,Aon,1],[Totaal,Vracht,t,Usercat,Pae,1],2.0)
	end
end #if

if toedelenVracht_etm
	writeln "   * vrachtautoverkeer"
	for m in [31,32]
		traffic 				= OtTraffic.new
		traffic.odMatrix 			= [Totaal,m,Etmaal,Usercat]
		traffic.network				= [Vracht,Restdag]
		traffic.load 				= [Totaal,m,Etmaal,Usercat,Aon,1] 
		traffic.routeFactors 			= [VrachtCostAfstand,VrachtCostTijd,0,0]
		traffic.numberOfThreads			= aantalThreads
		traffic.execute
	end
end


if toedelenAutoSpits
  writeln "   * personenauto's"

  for t in [2,3] 
  traffic							= OtTraffic.new
  traffic.assignMethod			= VOLUMEAVERAGING
  traffic.iterations				= 20
  traffic.junctions 				= true
  traffic.junctionParameters 		= [0.5,1.0]
  #traffic.junctionVersion 		= 20
  traffic.epsilon					= 0.00000001
  traffic.functionType			= 19
  traffic.bprPerType=[[[1..14,71..73],[0.5,4.0]], \
       [[20,21,23,25,62,68..70,74,75],[1.0,4.0]], \
       [[22,24,26..28,35..39,42,63,65],[1.5,4.0]], \
       [[40,41,64,66],[2.0,4.0]], \
       [[51,67],[4.0,4.0]], \
       [[52,53,55..58],[0.0,4.0]]]
  traffic.network			= [Auto,t]
  traffic.routeFactors 			= [AutoCostAfstand,AutoCostTijd,0,0]
  traffic.odMatrix			= [Totaal,Auto,t,103]
  traffic.load				= [Totaal,Auto,t,103,Va,20]
  traffic.preLoad			= [Totaal,Vracht,t,Usercat,Pae,1]
  traffic.numberOfThreads		= aantalThreads

  ################################################################################################
  traffic.skimMatrix = [Totaal,Auto,t,3,[Cost,Afstand,Tijd],1]
  traffic.skimFactors = [1.0,1.0,60.0]
  ################################################################################################	

  traffic.execute
  end
end

if toedelenAutoRdAon
  writeln "   * personenauto's"
  traffic 				= OtTraffic.new
  traffic.load 				= [Totaal,Auto,Restdag,101,151,1]
  traffic.routeFactors 			= [AutoCostAfstand,AutoCostTijd,0,0]
  traffic.numberOfThreads		= aantalThreads
  traffic.execute
end

if toedelenAutoRdVa 
  writeln "   * personenautoverkeer dalperiode toedelen"
  traffic							= OtTraffic.new
  traffic.assignMethod			= VOLUMEAVERAGING
  traffic.iterations 				= 20
  traffic.junctions 				= true
  traffic.junctionParameters 		= [0.5,1.0]
  #traffic.junctionVersion 		= 20
  traffic.epsilon					= 0.00000001
  traffic.functionType			= 19
  traffic.bprPerType=[[[1..14,71..73],[0.5,4.0]], \
       [[20,21,23,25,62,68..70,74,75],[1.0,4.0]], \
       [[22,24,26..28,35..39,42,63,65],[1.5,4.0]], \
       [[40,41,64,66],[2.0,4.0]], \
       [[51,67],[4.0,4.0]], \
       [[52,53,55..58],[0.0,4.0]]]
  traffic.network			= [Auto,Restdag]
  traffic.routeFactors 			= [AutoCostAfstand,AutoCostTijd]       
  traffic.odMatrix			= [Totaal,Auto,Restdag,101]
  traffic.pcuFactor 			= 1.0/RD_factor_auto
  traffic.load				= [Totaal,Auto,Restdag,141,Va,20]
  traffic.preLoad			= [[Totaal,Vracht,Restdag,Usercat,Pae,1],(1.0/RD_factor_vracht)]
  traffic.numberOfThreads		= aantalThreads

  ################################################################################################
  traffic.skimMatrix = [Totaal,Auto,1,3,[Cost,Afstand,Tijd],1]   # NOG check of dit goed is !!
  traffic.skimFactors = [1.0,1.0,60.0]
  ################################################################################################	

  traffic.execute

  #bewerken loads restdag autoverkeer (ophogen naar totaal restdag en verwijderen tussenload (nr 141)	
  writeln "   * autoloads restdag bewerken"
  network = OtNetwork.new
  network.copyLoad([Totaal,Auto,Restdag,141,Va,20],[Totaal,Auto,Restdag,101,Va,20],RD_factor_auto/1.0)
  network.deleteResults([Totaal,Auto,Restdag,141,Va,20])
   
end

if toedelenOV 
  for t in [1,2,3]
  transit=OtTransit.new
  transit.network 			= [Ov,t]
  transit.logitParameters		= [0.5,0.1,0.1]
  transit.load				= [Totaal,Ov,t,Usercat,Aon,1]
  transit.routeFactors			= [[0,1,60,60,60,1]]
  transit.minProbability 		= [0.02,0.02]
  transit.minFind 			= [[Lopen,1]]                   
  transit.searchRadius 			= [[Lopen,2.00]]       
  transit.maxInterchanges 		= 5
  transit.numberOfThreads		= aantalThreads


  ####################################################################
  transit.skimMatrix=[1,4,t,3,[1,2,3,4,5,6,7],1]
  ####################################################################

  transit.execute
  end
end
 
if toedelenFiets
  for t in [1,2,3]
  writeln "   * fiets"
  traffic 					= OtTraffic.new
  traffic.load 					= [Totaal,Fiets,t,Usercat,Aon,1]
  traffic.numberOfThreads			= aantalThreads

  ####################################################################
  traffic.skimMatrix = [Totaal,Fiets,t,3,[Cost,Afstand,Tijd],1]
  traffic.skimFactors = [1.0,1.0,60.0]
  ####################################################################

  traffic.execute
  end
end

writeln "Einde toedelingen"
