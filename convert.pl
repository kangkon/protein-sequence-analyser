#!/usr/bin/perl
use strict;
use warnings;

print "Enter FASTA file name [default: sequence.fasta]: ";
my $filename = <>;
chomp $filename;

# Set default filename sequence.fasta if filename is empty
if ($filename eq '') {
  $filename = 'sequence.fasta';
}


open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# get the first line from the file handler contents
my $seq_info = <$fh>;
chomp $seq_info;

my $sequence = '';
# Iteratitively extract all the other lines containing sequence
while (my $row = <$fh>) {
  chomp $row;
  $sequence .= $row;
}
close $fh;

my $sequence_length = length($sequence);
my %amino_acid_dict = (
   'A' => 'Ala',
   'R' => 'Arg',
   'N' => 'Asn',
   'D' => 'Asp',
   'C' => 'Cys',
   'E' => 'Glu',
   'Q' => 'Gln',
   'G' => 'Gly',
   'H' => 'His',
   'I' => 'Ile',
   'L' => 'Leu',
   'K' => 'Lys',
   'M' => 'Met',
   'F' => 'Phe',
   'P' => 'Pro',
   'S' => 'Ser',
   'T' => 'Thr',
   'W' => 'Trp',
   'Y' => 'Tyr',
   'V' => 'Val'

);

#Unconverted sequence
print ("Source:\n $sequence\n");

foreach my $amino_acid (keys %amino_acid_dict) {
  #Algorithm: Match a single amino acid letter with negative lookahead for lowercase letter
  $sequence =~ s/$amino_acid(?![a-z])/$amino_acid_dict{$amino_acid}-/g;
}
# Remove last character of sequence
chop($sequence);

# Print output file
my $output_filename = "converted-$filename";
open($fh, '>', $output_filename) or die "Could not write file '$output_filename' $!";
print $fh "$seq_info\n$sequence";
close $fh;

print ("\nConverted:\n $sequence\n");
