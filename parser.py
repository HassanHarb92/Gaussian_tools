#!/usr/bin/python

from __future__ import division
import sys
import math
import numpy as np
from numpy import genfromtxt
import csv
from decimal import Decimal 
import os

#######################################################################################################################
#
#  Parser v 1.0
#  By Hassan Harb
#
#  Program that pulls out matrices from checkpoint file and stores them in .mat files
#
#  usage: python parser.py checkpointfile.fchk
#
#
#  Last edited by Hassan Harb, September 13, 2018
#
#######################################################################################################################


#Function: Symmetrize: Transform packed array into NBasis x NBasis 
def symmetrize(a):
  Nbas = int((np.sqrt(8*len(a)+1)-1)/2)
  b = np.zeros((Nbas,Nbas))
  n = 0
  for i in range(0,Nbas):
    for j in range(0,i+1):
      b[i,j]=a[n]
      b[j,i]=a[n]
      n=n+1
  return b

#Function: convert output to scientific notation
def sci_notation(n):
    a = '%.8E' % n
    return '%.8E' % Decimal(n)

#Part 1: Read in the matrix files from two checkpoint files
AElec = 0
BElec = 0
NElec = 0
NBasis = 0
filename1 = sys.argv[1]
acc = 8 #accuracy to the acc's decimal place

print "Checkpoint:", filename1
 
with open(filename1,'r') as origin:
    for line in origin:
        if  "Number of basis functions" in line:
          words = line.split()
          for i in words:
              for letter in i:
                  if(letter.isdigit()):
                      NBasis = NBasis*10 + int(letter)   
        if "Number of alpha electrons" in line:
          words = line.split()
          for i in words:
              for letter in i:
                  if(letter.isdigit()):
                      AElec = AElec*10 + int(letter)

        if "Number of beta electrons" in line:
          words = line.split()
          for i in words:
              for letter in i:
                  if(letter.isdigit()):
                      BElec = BElec*10 + int(letter)
NElec = AElec + BElec
NOccA = AElec
NOccB = BElec
NVirA = NBasis - NOccA
NVirB = NBasis - NOccB
print "Number of Basis Functions = ", NBasis, "\n"
print "Number of Alpha Electrons = ", AElec, "\n"
print "Number of Beta Electrons = ", BElec, "\n"
print "Total Number of Electrons = ", NElec, "\n"
print "Number of Alpha Virtual Orbitals = ", NVirA, "\n"
print "Number of Beta Virtual Orbitals = ", NVirB, "\n"
MOElements = NBasis * NBasis
print "The code will look for ", MOElements, " elements of the MO Coeffienct matrix\n"
PElements = int(NBasis*(NBasis+1)/2)
print "The code will look for ", PElements, " elements of the Density matrix\n"
NBasis2=0

MOlines = int(MOElements/5) + 1
Plines = int(PElements/5) + 1

if (MOElements % 5 ==0):
   MOlines = int(MOElements/5)
if (PElements % 5 ==0):
   Plines = int(PElements/5)

print "MO Lines = ", MOlines, "\n"
print "P Lines = ", Plines, "\n"

MOraw = np.zeros(MOElements)
TotalPraw1 = np.zeros(PElements) 
SpinPraw1 = np.zeros(PElements)

p = 0
r = 0
AOE = 0
with open(filename1,'r') as origin:
    for i, line  in enumerate(origin):
        if "Alpha Orbital Energies" in line:
              AOE = i
        if  "Alpha MO coefficients" in line:              
              i=i+1
              AMO=i
              print "Alpha MO coefficients starts at line :", i
              j=i+MOlines-1
              print "Alpha MO coefficients ends at line :", j
              for m in range(0,j-i+1):
                 nextline = origin.next()
                 nextline = nextline.split()
                 for p in range(p,len(nextline)):
                   MOraw[r] = nextline[p]
                   r = r+1
                 p = 0
        if "Beta MO coefficients" in line:
              i=i+1
              BMO = i
        if  "Total SCF Density" in line:
              i=i+1
              r = 0
              p = 0
              print "Total SCF Density starts at line :", i
              j=i+Plines-1
              print "Total SCF Density ends at line :", j
              for m in range(0,j-i+1):
                 nextline = origin.next()
                 nextline = nextline.split()
                 for p in range(p,len(nextline)):
                   TotalPraw1[r] = nextline[p]
                   r = r+1
                 p = 0
        if  "Spin SCF Density" in line:
              i=i+1
              r = 0
              p = 0
              print "Spin SCF Density starts at line: ", i
              j=i+Plines-1
              print "Spin SCF Density ends at line: ", j
              for m in range(0,j-i+1):
                 nextline = origin.next()
                 nextline = nextline.split()
                 for p in range(p,len(nextline)):
                   SpinPraw1[r] = nextline[p]
                   r = r+1
                 p = 0

MOraw = np.around(MOraw,decimals=acc)
TotalPraw1 = np.around(TotalPraw1,decimals=acc)
SpinPraw1 = np.around(SpinPraw1,decimals=acc)

print "Stored Alpha MO Coefficients matrix = \n", MOraw
print "Stored Total SCF Density matrix = \n", TotalPraw1
print "Stored Spin SCF Density matrix = \n", SpinPraw1

PalphaRaw1 = (np.add(TotalPraw1,SpinPraw1)) * 0.5
PbetaRaw1 = (np.subtract(TotalPraw1,SpinPraw1)) * 0.5 

print "Ground state: Alpha Density matrix =\n", PalphaRaw1
print "Ground state: Beta Density matrix =\n", PbetaRaw1

P1a = np.zeros((NBasis,NBasis))
P1b = np.zeros((NBasis,NBasis))

#Density Matrices

P1a = symmetrize(PalphaRaw1)
P1b = symmetrize(PbetaRaw1)

print "Alpha Density 1 = \n", P1a
print "Beta Density 1 = \n", P1b

#MO Coefficient Matrix
C = np.zeros((NBasis,NBasis))
t=0
for i in range(0,NBasis):
   for j in range(0,NBasis):
     C[j,i]=MOraw[t]
     t=t+1

print "MO Coefficient Matrix = \n", C

#Inverse of C:
CInv = np.linalg.inv(C)
#Overlap Matrix:
# S = (C**(-1)t*(C**(-1))
S = np.dot(np.transpose(CInv),CInv)
print "Overlap Matrix = \n", S

print "Copying Matrices to .dat files ... "
np.savetxt('overlap.dat',S,delimiter = ' ')
np.savetxt('alphaP.dat',P1a,delimiter = ' ')
np.savetxt('betaP.dat',P1b,delimiter = ' ')
np.savetxt('alphaC.dat',C,delimiter = ' ')
print "Copying data to new checkpoint file: DONE"
