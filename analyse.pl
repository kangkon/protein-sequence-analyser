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

# Delete first > symbol
$seq_info = reverse($seq_info);
chop($seq_info);
$seq_info = reverse($seq_info);

my $sequence = '';
# Iteratitively extract all the other lines containing sequence
while (my $row = <$fh>) {
  chomp $row;
  $sequence .= $row;
}

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

my %count;

foreach my $amino_acid (keys %amino_acid_dict) {
  $count{$amino_acid} = () = $sequence =~ /$amino_acid/g;
}

# Print Output
print "========================================================================= \n";
print " Protein Sequence Analysis Report \n";
print "========================================================================= \n";
print "     Filename: $filename\n";
print "     Info: $seq_info \n";
print "     Sequence Length: $sequence_length Amino Acids \n\n";
print "------------------------------------------------------------------------- \n";
print " Amino Acid \t Abbr \t Occurance \t Content (%) \n";
print "------------------------------------------------------------------------- \n\n";
foreach my $amino_acid (keys %amino_acid_dict) {
  my $content = $count{$amino_acid} * 100/$sequence_length;
  printf "  %s \t\t %s \t %d \t\t %.2f \n", $amino_acid_dict{$amino_acid}, $amino_acid, $count{$amino_acid}, $content;
}
print "-------------------------------------------------------------------------- \n";
my $essentiam_percent = ($count{'H'} + $count{'I'} + $count{'L'} + $count{'K'} + $count{'F'} + $count{'M'} + $count{'T'} + $count{'W'} + $count{'V'}) * 100 / $sequence_length;
printf "  Essential Amino acid Percentage: %.2f\n", $essentiam_percent;
print "-------------------------------------------------------------------------- \n";
