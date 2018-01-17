# OmniTRANS Job 
# Created 11-03-2010  JRI
# STADSONTWIKKELING / STADSREGIO ROTTERDAM
# =========================================================================================
  writeln "Inlezen parameter bestanden..."
# =========================================================================================
  load $Ot.dirJob+'Simjobs\parameters_rvmk3_rtd2010.rb'
  include Parameters_rtd
# =========================================================================================
#
# schrijft tekstfiles met reistijden
# en met bereikbare inwoners, arbeidsplaatsen, leerlingplaatsen
#
# =========================================================================================

writeln "-------------------------------------------------------"
writeln "Aantal bereikbare arbeidsplaatsen inwoners llp OV"
writeln "-------------------------------------------------------"

# Parameters
Sim=['smc2015rvmk33_sbbb']
Aantalzones=5791
reistijden=[45]  # voor deze reistijdklasse(s) rekenen

# Start

for matrixnm in Sim

	writeln "Open matrix: ", matrixnm
	m=OtMatrixCube.new(matrixnm)
	
	# get zonal data: inw, arbpl 
	writeln "inwoners"
	inwon=m.zonalData('inwoners')
	writeln inwon.sum

	#writeln "woningen"
	#wonin=m.zonalData('woningen')
	#writeln wonin.sum

	writeln "arbeidsplaatsen"
	arbpl=m.zonalData('arbeidspl_totaal')
	writeln arbpl.sum
	
	writeln "bbv"
	bbv=m.zonalData('bbv')
	writeln bbv.sum
		
	writeln "leerlingplaatsen"
	llpla=m.zonalData('llp12eo')
	writeln llpla.sum

	writeln "Reading Skims..."
	skimmat=OtSkimCube.open()
	# reistijden ov
	  ovrd=skimmat[1,4,1,3,3,1] #OV restdag   3 = reistijd
	  ovos=skimmat[1,4,2,3,3,1] #OV os
	  ovas=skimmat[1,4,3,3,3,1] #OV as

	# reistijden auto
	# aurd=skimmat[1,2,1,3,3,1] #auto restdag
	# auos=skimmat[1,2,2,3,3,1] #auto os
	# auas=skimmat[1,2,3,3,3,1] #auto as

	# reistijden fiets
	# ftrd=skimmat[1,5,1,3,3,1] #fiets restdag
	# ftos=skimmat[1,5,2,3,3,1] #fiets os
	# ftas=skimmat[1,5,3,3,3,1] #fiets as


	## kale reistijd ########################################################
	filepath1 = 'D:\\---ov----'+'2015.txt'
	writeln 'Writing: ',filepath1
	unit1 = File.new(filepath1,'w+')
	unit1.print "zone h;zone b;RTOVrd15;RTOVos15;RTOVas15\n"
	for i in 1..Aantalzones
		for j in 1..Aantalzones

			#unit1.print i,";",j,";",ovrd[i,j].to_s ,";",ovos[i,j].to_s ,";",ovas[i,j].to_s ,"\n"
			unit1.print i,";",j,";", "%.2f" % ovrd[i,j],";", "%.2f" % ovos[i,j],";" , "%.2f" % ovas[i,j],"\n"
		end
	end
	writeln 'Einde (1)'
	##/kale reistijd ########################################################


	for rt in 0..reistijden.length-1

		reistijd=reistijden[rt]
		writeln "Klasse ",rt+1," van ", reistijden.length.to_s, "  Reistijd ", reistijd.to_s

		#------------------------------------------------------------------------------------------------#		
		writeln "* ov ochtendspits"
		
		# schrijf altijd deze arbpl,inwoners file
		filepath2 = 'D:\\hb-ov-os-'+reistijd.to_s+'2015.txt'
		writeln 'Writing: ',filepath2
		unit2 = File.new(filepath2,'w+')

		# schrijf altijd deze arbpl,inwoners file
		filepath3 = 'D:\\h--ov-os-'+reistijd.to_s+'2015.txt'
		writeln 'Writing: ',filepath3
		unit3 = File.new(filepath3,'w+')

		# file header
		unit2.print "zone h;zone b;ovos;inwoners;arbpl;llp12eo\n"
		unit3.print "zone h"+";INovOS"+reistijd.to_s+";APovOS"+reistijd.to_s+";LLovOS"+reistijd.to_s+"\n"

		writeln "* writing files..."
		for i in 1..Aantalzones
			
			somarbpl=0
			sominwon=0
			somllpla=0


			for j in 1..Aantalzones
				if ovos[i,j] < reistijd then  
					unit2.print i,";",j,";",ovos[i,j].to_s,";",inwon[j].to_s,";",arbpl[j].to_s,";",llpla[j].to_s,"\n"
					sominwon=sominwon+inwon[j].to_i
					somarbpl=somarbpl+arbpl[j].to_i
					somllpla=somllpla+llpla[j].to_i
				end
			end #j
			unit3.print i,";",sominwon.to_s,";",somarbpl.to_s,";",somllpla.to_s,"\n"
		end #i
		unit2.close
		unit3.close

		#------------------------------------------------------------------------------------------------#
		writeln "* ov avondspits SKIPPED"
		#------------------------------------------------------------------------------------------------#
		writeln "* ov restdag SKIPPED"
		#------------------------------------------------------------------------------------------------#
		
		
		writeln "* Einde reistijd ", (rt+1).to_s
	end #rt
end #m

writeln "Einde script"
# Einde
