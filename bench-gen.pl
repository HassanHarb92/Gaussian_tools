#! /usr/bin/perl
#! /bin/bash
#Benchmarking v1.0
#This script generates different file of the same geometry, each with a specific density functional used
#The script needs a list of functionals to use as an input, it will also require the geometry of the molecule
#The script will output a set of gaussian input files that would be ready for submission

use strict;
use warnings;
use 5.010;

my $funcfile="null";
my $funcnum="0";

print "Welcome to Benchmarker, the dummy script that will help you generate different input files using different functionals\n";
print "Please enter the name of the file where your functional list is";
 $funcfile=<STDIN>;
chomp $funcfile;

open(my $fh, '<:encoding(UTF-8)', $funcfile)
  or die "Could not open file '$funcfile' $!";

while (my $row = <$fh>) {
   chomp $row;
   print "$row\n";
}

