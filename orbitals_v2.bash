#! /bin/bash
#
#################################################################################
#                                                                               #
#   Orbital v1.0                                                                #
#   By Hassan Harb                                                              #
#   This program pulls out the energies of the lowest 15 occupied orbitals in a #
#    set of gaussian files                                                      #
#   The program sets up output files to view the change in orbital energies as  #
#    the angle changes (raw data for Walsh Diagram)                             #
#   usage: ./orbitals.bash                                                      #
#   output: <Orbitalnumber.dat>                                                 #
#                                                                               #
#   Copyleft: 'The script may be used, modified, and distributed freely'        #
#                                                                               #
#################################################################################

#Set up the loop to read files in the directory

echo "Angle  EHOMO  EHOMO-1  EHOMO-2  EHOMO-3  EHOMO-4  EHOMO-5  EHOMO-6  EHOMO-7  EHOMO-8  EHOMO-9  EHOMO-10  EHOMO-11  EHOMO-12  EHOMO-13  EHOMO-14" >> all.out

for inputfile in $(ls *.log); do

#part 1: Pull out the data from the log files
Angle=`cat $inputfile |  grep -A 7 Parameters *.log | grep A1 | tail -1 | awk '{print $(NF-4)}'`
EHomo=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -1 | awk '{print $(NF)}'`
EHomo01=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -1 | awk '{print $(NF-1)}'`
EHomo02=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -1 | awk '{print $(NF-2)}'`
EHomo03=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -1 | awk '{print $(NF-3)}'`
EHomo04=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -1 | awk '{print $(NF-4)}'`
EHomo05=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -2 | head -1 | awk '{print $(NF)}'`
EHomo06=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -2 | head -1 | awk '{print $(NF-1)}'`
EHomo07=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -2 | head -1 | awk '{print $(NF-2)}'`
EHomo08=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -2 | head -1 | awk '{print $(NF-3)}'`
EHomo09=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -2 | head -1 | awk '{print $(NF-4)}'`
EHomo10=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -3 | head -1 | awk '{print $(NF)}'`
EHomo11=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -3 | head -1 | awk '{print $(NF-1)}'`
EHomo12=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -3 | head -1 | awk '{print $(NF-2)}'`
EHomo13=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -3 | head -1 | awk '{print $(NF-3)}'`
EHomo14=`cat $inputfile | grep " Alpha  occ. eigenvalues"  | tail -3 | head -1 | awk '{print $(NF-4)}'`

#part 2: write the different orbital energies to outputfiles

echo $Angle " " $EHomo >> Ehomo.dat
echo $Angle " " $EHomo01 >> Ehomo01.dat
echo $Angle " " $EHomo02 >> Ehomo02.dat
echo $Angle " " $EHomo03 >> Ehomo03.dat
echo $Angle " " $EHomo04 >> Ehomo04.dat
echo $Angle " " $EHomo05 >> Ehomo05.dat
echo $Angle " " $EHomo06 >> Ehomo06.dat
echo $Angle " " $EHomo07 >> Ehomo07.dat
echo $Angle " " $EHomo08 >> Ehomo08.dat
echo $Angle " " $EHomo09 >> Ehomo09.dat
echo $Angle " " $EHomo10 >> Ehomo10.dat
echo $Angle " " $EHomo11 >> Ehomo11.dat
echo $Angle " " $EHomo12 >> Ehomo12.dat
echo $Angle " " $EHomo13 >> Ehomo13.dat
echo $Angle " " $EHomo14 >> Ehomo14.dat

echo $Angle $EHomo $EHomo01 $EHomo02 $EHomo03 $EHomo04 $EHomo05 $EHomo06 $EHomo07 $EHomo08 $EHomo09 $EHomo10 $EHomo11 $EHomo12 $EHomo13 $EHomo14  >> all.out

done


