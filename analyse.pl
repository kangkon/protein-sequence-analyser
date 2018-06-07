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

# Store the counted amino acids in the sequence
my %count;

foreach my $amino_acid (keys %amino_acid_dict) {
  $count{$amino_acid} = () = $sequence =~ /$amino_acid/g;
}
my $essential_am = $count{'H'} + $count{'I'} + $count{'L'} + $count{'K'} + $count{'F'} + $count{'M'} + $count{'T'} + $count{'W'} + $count{'V'};

# Manage Output
my $file_format = 0;
while ($file_format < 1 || $file_format > 2) {
  print " Print output as: \n\t [1] TXT\n\t [2] CSV\n Enter your choice here: ";
  $file_format = <>;
  $file_format = int($file_format);
}
my $output_filename = "report";

if ($file_format == 2) {
  $output_filename .= '.csv';
}else {
  $output_filename .= '.txt';
}
print "Enter Output File Name [default $output_filename]: ";
my $output_filename_input = <>;
chomp $output_filename_input;
if ($output_filename_input ne '') {
  $output_filename = $output_filename_input;
}

# Missing amino acids
my $missing_aa_count = 0;
my $missing_aa = '';

my $csv_report = '',
my $report = '';

# Print Output
$report .= "========================================================================= \n";
$report .= " Protein Sequence Analysis Report \n";
$report .= "========================================================================= \n";
$report .= "     Filename: $filename\n";
$report .= "     Info: $seq_info \n";
$report .= "     Sequence Length: $sequence_length Amino Acids \n\n";
$report .= "------------------------------------------------------------------------- \n";
$report .= " Amino Acid \t Abbr \t Occurance \t Content (%) \n";
$report .= "------------------------------------------------------------------------- \n\n";
foreach my $amino_acid (keys %amino_acid_dict) {
  my $content = $count{$amino_acid} * 100/$sequence_length;
  $report .= sprintf("  %s \t\t %s \t %d \t\t %.2f \n", $amino_acid_dict{$amino_acid}, $amino_acid, $count{$amino_acid}, $content);
  $csv_report .= "$amino_acid_dict{$amino_acid}, $amino_acid, $count{$amino_acid},".sprintf("%.2f", $content)."\n";
  if ($count{$amino_acid} == 0) {
    $missing_aa_count += 1;
    $missing_aa .= "$amino_acid_dict{$amino_acid}, ";
  }
}
$report .= "------------------------------------------------------------------------- \n";
$report .= sprintf("  Essential Amino Acids : %d (%.2f percent)\n", $essential_am, $essential_am * 100 / $sequence_length);

if ($missing_aa_count > 0){
    # Remove last white space and comma
    chop($missing_aa);
    chop($missing_aa);
    $report .= sprintf("  Missing Amino Acids [%d]: %s\n", $missing_aa_count, $missing_aa);
}

$report .= "------------------------------------------------------------------------- \n";

open($fh, '>', $output_filename) or die "Could not write file '$output_filename' $!";
if ($file_format == 2) {
  print $fh "Protein Sequence Analysis Report\n";
  print $fh "Filename: $filename\nInfo: $seq_info\nSequence Length: $sequence_length Amino Acids\n";
  print $fh "Amino Acid,Abbr,Occurance,Content (%)\n";
  print $fh $csv_report;
  print $fh "Essential Amino Acids, $essential_am, ".sprintf("(%.2f ", $essential_am * 100 / $sequence_length)." %)\n";
  if ($missing_aa_count > 0){
      print $fh "Missing Amino Acids,$missing_aa_count,$missing_aa";
  }
} else {
  print $fh $report;
}
close $fh;

print $report;
