# OmniTRANS Job for 'OT_rtd176_2'
# Created 1-10-2007 17:01:01
# 
# 1. 23-10-2013 PAE ook voor m=31 en m=32   JRI 
#
#
# =========================================================================================
  writeln "Inlezen parameter bestanden..."
# =========================================================================================
  load $Ot.dirJob+'Simjobs\parameters_rvmk3_rtd2010.rb'
  include Parameters_rtd
# =========================================================================================

			traffic 						= OtTraffic.new
			traffic.network     = [2,1]
      traffic.skimMatrix  = [Totaal,2,1,101,[0,1,0],1] # skim auto restdag test
			traffic.execute
		
