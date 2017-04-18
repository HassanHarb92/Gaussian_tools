#! /bin/bash
#
#################################################################################
#                                                                               #
#   Comp-details v1.0                                                           #
#   By Hassan Harb                                                              #
#   This script pulls out the compuational detailsfrom a gaussian output file   #
#                                                                               #
#   usage: ./molprop.bash <filename>                                            #
#   output: Enthalpy, Free Energy, E+ZPE, SCF Energy, S-squared                 #
#                                                                               #
#   Copyleft: 'The script may be used, modified, and distributed freely'        #
#                                                                               #
#################################################################################

inputfile=$1

#part 1: data extraction
NBasis=`cat $inputfile | grep "primitive gaussians" | tail -1 | awk '{print $NR}'`;
Nprimitive=`cat $inputfile | grep "primitive gaussians" | tail -1 | awk '{print $(NR+3)}'`;
Ncart=`cat $inputfile | grep "primitive gaussians" | tail -1 | awk '{print $(NR+6)}'`;

#part 2: print

echo "File: "  $inputfile
echo "Number of basis functions: " $NBasis
echo "Number of primitive gaussians: " $Nprimitive
echo "Number of cartesian basis functions: " $Ncart




