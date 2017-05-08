#! /usr/bin/perl

#Dummy Perl v1.0
#By Hassan Harb
#This program generates different electronic states for diatomics and triatomics
#The main purpose of this version is to generate the input files for a Gaussian Job that calculates the electronic
#energies of all possible electronic states for Lanthanide Oxides, Hydroxides, and Hydrides.
#This version produces both the anions and the neutrals

use strict;
use warnings;
use 5.010;

my $lswitch = 0;
my $ligand = "null";
my $filename = "null";
my $linker2="null";
print "Welcome to this dummy perl script\n";
#This part allows the user to choose between diatomic and triatomic molecules
print "To start, please type in D for diatomics or T for triatomics\n";
my $DorT =<STDIN>;
chomp $DorT;
if ($DorT eq "D")
{	print "So we will begin with generating the diatomics\n";
#For diatomic molecules, we get the option to choose between Oxides and Hydrides 
	print "Please enter O for oxide or H for hydride\n";
	 $linker2=<STDIN>;
	chomp $linker2;
	if ($linker2 eq "O") {
		print "Oxide was selected!\n";
		$lswitch=1;
		$ligand = "Oxide";
}
	elsif ($linker2 eq "H")  {
		print "Hydride was selected!\n";	
		$lswitch=2;
		$ligand="Hydride";
}
	else {	
		print "Sorry, invalid operation\n";
		exit;
}
}
elsif ($DorT eq "T")
{	print "So we will begin with generating the triatomics\n";
	$ligand="Hydroxide";
}
else {
	print "Sorry, invalid option\n";
	exit;
}
#In this part, we ask the user to input the atomic symbol and the atomic number of the lanthanide
print "Please type the atomic symbol of the heavy metal followed by its atomic number\n";
my $HeavyA = <STDIN>;
chomp $HeavyA;
my $Anum=<STDIN>;
my $totale=0;
#calculate the different possible spin states for the anion and the neutral di/tri atomics	
if ($lswitch eq 1) {
	$totale=$Anum+8;
}
elsif ($lswitch eq 2) {
	$totale=$Anum+1;
}
elsif ($lswitch eq 0) {
	$totale=$Anum+9;
}
else {
	print "something went wrong..\n";
	exit;
}
my $iseven=0;
if ($totale%2 eq 0) {
	$iseven=1;
}
####################
###################

print "Please enter the functional that you want to use\n";
my $functional = <STDIN>;
chomp $functional;

print "Choose your basis sets for the Lanthanides, two options are available: \n";
print "A. COLOGNE-DKH2\n";
print "B. SARC-ZORA\n";
my $choice = <STDIN>;
chomp $choice;

my $basisset = "null";

if ($choice eq "A") {
	print "the selected basis set is COLOGNE-DKH2\n";
	$basisset = "COLOGNE-DKH";
}
elsif ($choice eq "B") {
	print "The selected basis set is SARC-ZORA\n";
	$basisset = "SARC-ZORA";	
}
#this part will be creating the files, adding the command lines and the z matrix
$filename="$HeavyA-$ligand";
if ($iseven eq 1)  {
	print "The lowest spin states for the anion $HeavyA $ligand are: \n";
	for ( my $i=2 ; $i<=10; $i+=2) {
		
		chomp $i;
		my $filename2="$filename-anion-$i";
		print "$filename2\n";
		my $file = "$filename2.com";
		unless (open FILE, '>'.$file) {
		die "\nUnable to create $file\n";
		}
		print FILE "\%chk=$filename2.chk\n";
		print FILE "#p $functional gen scf=(novaracc,maxcycles=512,fermi,xqc) integral=(grid=ultrafine,acc2e=12,DKH)\nOpt Freq\n\n";
		print FILE "Title file for $HeavyA $ligand anion\n\n";
		print FILE "-1 $i\n"; 
		if ( $DorT eq "D") {
			print FILE "$linker2  \n$HeavyA          1          B1\n\n  B1     2.50000\n\n$linker2 0\naug-cc-pvtz\n****\n";
		}
		if ($DorT eq "T") {
			print FILE "O\nH          1          B1\n$HeavyA          1          B2    2          A1\n\nB1    0.96666\nB2    2.510000 \nA1     175.000\n";
			print FILE "\nO H 0\naug-cc-pvtz\n****\n";
		}
		print FILE "$HeavyA  0\n";
		#need to insert a commaand that reads from the basis set file and copies it to the input file
		#this needs to be done for the four secments of this nested if statement
##########################################
#		if ($basisset eq "SARC-ZORA") {
#			### write the zora basis set 
#		}
#		elsif ($basisset eq "COLOGNE-DKH2") {
#			### write the cologne basis set
#		}
               # if ($basisset eq "SARC-ZORA") {
                my $bsf = "$basisset";
                open (my $fh, '<:encoding(UTF-8)',$bsf)
                or die "Could not locate the basis sets file";
                while (my $row = <$fh>) {
                        chomp $row;
                print FILE "$row\n";
                }
               # }				
		close FILE;
	}
	print "The lowest spin states for the neutral $HeavyA $ligand are: \n";
	for ( my $i=1 ; $i<=10; $i+=2) {
                
		chomp $i;
                my $filename2="$filename-neutral-$i";
                print "$filename2\n";
		my $file="$filename2.com";
		unless (open FILE, '>'.$file) {
		die "\nUnable to create $file\n";
		}
		print FILE "\%chk=$filename2.chk\n";
                print FILE "#p $functional gen scf=(novaracc,maxcycles=512,fermi,xqc) integral=(grid=ultrafine,acc2e=12,DKH)\nOpt Freq\n\n";
                print FILE "Title file for $HeavyA $ligand neutral\n\n";
                print FILE "0 $i\n";
                if ( $DorT eq "D") {
                        print FILE "$linker2  \n$HeavyA          1          B1\n\n  B1     2.50000\n\n$linker2 0\naug-cc-pvtz\n****\n";
                }
                if ($DorT eq "T") {
                        print FILE "O\nH          1          B1\n$HeavyA          1          B2    2          A1\n\nB1    0.96666\nB2    2.510000 \nA1     175.000\n";
                        print FILE "\nO H 0\naug-cc-pvtz\n****\n"; 
                }
                print FILE "$HeavyA  0\n";
#               if ($basisset eq "SARC-ZORA") {
#               ### write the zora basis set
#               }
#               elsif ($basisset eq "COLOGNE-DKH2") {
#               ### write the cologne basis set
#               }
               # if ($basisset eq "SARC-ZORA") {
		my $bsf = "$basisset";
		open (my $fh, '<:encoding(UTF-8)',$bsf)
		or die "Could not locate the basis sets file";
		while (my $row = <$fh>) {
			chomp $row;
		print FILE "$row\n";
		}
	#	}
		close FILE;
	       
	}
}

elsif ($iseven eq 0)  {
        print "The lowest spin states for the neutral $HeavyA $ligand are: \n";
        for ( my $i=2 ; $i<=10; $i+=2) {
                
		chomp $i;
	  	my $filename2="$filename-neutral-$i";
		print "$filename2\n";
		my $file="$filename2.com";
		unless (open FILE, '>'.$file)  {
		die "\nUnable to create $file\n";
		}
		print FILE "\%chk=$filename2.chk\n";
		print FILE "#p $functional gen scf=(novaracc,maxcycles=512,fermi,xqc) integral=(grid=ultrafine,acc2e=12,DKH)\nOpt Freq\n\n";
		print FILE "Title file for $HeavyA $ligand neutral\n\n";
		print FILE "0 $i\n";
		if ($DorT eq "D") {
			print FILE "$linker2 \n$HeavyA          1          B1\n\n   B1     2.500000\n\n$linker2 0\naug-cc-pvtz\n****\n";
		}
		if ($DorT eq "T") {
                        print FILE "O\nH          1          B1\n$HeavyA          1          B2    2          A1\n\nB1    0.96666\nB2    2.510000 \nA1     175.000\n";
                        print FILE "\nO H 0\naug-cc-pvtz\n****\n";
		}
		print FILE "$HeavyA 0\n";
#               if ($basisset eq "SARC-ZORA") {
#                       ### write the zora basis set
#               }
#               elsif ($basisset eq "COLOGNE-DKH2") {
#                       ### write the cologne basis set
#               }
 #               if ($basisset eq "SARC-ZORA") {
                my $bsf = "$basisset";
                open (my $fh, '<:encoding(UTF-8)',$bsf)
                or die "Could not locate the basis sets file";
                while (my $row = <$fh>) {
                        chomp $row;
                print FILE "$row\n";
                }
  #              }
		close FILE;
}
        print "The lowest spin states for the anion $HeavyA $ligand are: \n";
        for ( my $i=1 ; $i<=10; $i+=2) {
		chomp $i;
		my $filename2="$filename-anion-$i";
		print "$filename2\n";		 
		my $file="$filename2.com";
		unless (open FILE,'>'.$file)  {
		die "\nUnable to create $file\n";
		}
		print FILE "\%chk=$filename2.chk\n";
		print FILE "#p $functional gen scf=(novaracc,maxcycles=512,fermi,xqc) integral=(grid=ultrafine,acc2e=12,DKH)\nOpt Freq\n\n";
		print FILE "Title file for $HeavyA $ligand anion\n\n";
		print FILE "-1 $i\n";
		if ($DorT eq "D") {
			print FILE "$linker2 \n$HeavyA          1          B1\n\n   B1     2.500000\n\n$linker2 0\naug-cc-pvtz\n****\n";
		}
		if ($DorT eq "T") {
                        print FILE "O\nH          1          B1\n$HeavyA          1          B2    2          A1\n\nB1    0.96666\nB2    2.510000 \nA1     175.000\n";
                        print FILE "\nO H 0\naug-cc-pvtz\n****\n";
		}
		print FILE "$HeavyA 0\n";
#               if ($basisset eq "SARC-ZORA") {
#                       ### write the zora basis set
#               }
#               elsif ($basisset eq "COLOGNE-DKH2") {
#                       ### write the cologne basis set
#               }
 #               if ($basisset eq "SARC-ZORA") {
                my $bsf = "$basisset";
                open (my $fh, '<:encoding(UTF-8)',$bsf)
                or die "Could not locate the basis sets file";
                while (my $row = <$fh>) {
                        chomp $row;
                print FILE "$row\n";
  #              }
                }
		close FILE;
 
      }
}
print "The command line:\n";
print "#p $functional gen scf=(novaracc,maxcycles=512,fermi,xqc) integral=(grid=ultrafine,acc2e=12,DKH)\nOpt Freq\n";
print "The calculations will be performed for $HeavyA $ligand using $functional functional and $basisset basis sets\n";

