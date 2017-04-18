#! /bin/bash 
#################################################################################
#                                                                               #
#   MolProp_all: Molecule-properties v1.1                                       #
#   By Hassan Harb                                                              #
#   This script pulls out the molecule's summary from a list of                 #
#     gaussian output files in a given directory                                #
#                                                                               #
#   usage: ./molprop_all.bash                                                   #
#   output: filename(s), Enthalpy, Free Energy, E+ZPE, SCF Energy, S-squared    #
#                                                                               #
#   Copyleft: 'The script may be used, modified, and distributed freely'        #
#                                                                               #
#################################################################################


for inputfile in $(ls *.log); do

#part 1: data extraction:
Termination=`cat $inputfile | grep "termination" | tail -1 | awk '{print $NR}'`;
Enthalpy=`cat $inputfile | grep "Sum of electronic and thermal Enthalpies" | tail -1 | awk '{print $NF}' `;
FreeEnergy=`cat $inputfile | grep "Sum of electronic and thermal Free Energies" | tail -1 | awk '{print $NF}' `;
EPlusZPE=`cat $inputfile | grep "Sum of electronic and zero-point Energies" | tail -1 | awk '{print $NF}' `;
SCFEnergy=`cat $inputfile | grep "SCF Done"  | awk '{print $(NF-4)}' `;
SCFEnergy=`echo $SCFEnergy | awk '{print $NF}'`;
SSquared=`cat $inputfile | grep "<S\*\*2>" | awk '{print $(NF-2)}' `;
SSquared=`echo $SSquared | awk '{print $NF}'`;

#part 2: Convert to desired units
Enthalpy=$(echo "scale=8; ($Enthalpy)*(627.5)" | bc -l);
FreeEnergy=$(echo "scale=8; ($FreeEnergy)*(627.5)" | bc -l);
EPlusZPE=$(echo "scale=8; ($EPlusZPE)*(627.5)" | bc -l);

#part 3: Print 
echo "File: " $inputfile
echo $Termination "termination of the job" 
echo "Enthalpy: " $Enthalpy "Kcal/mol"
echo "Free Energy: " $FreeEnergy "Kcal/mol"
echo "E + ZPE: " $EPlusZPE "Kcal/mol"
echo "SCF Energy: " $SCFEnergy "Hartrees"
echo "S Squared: " $SSquared 
echo " "

done

