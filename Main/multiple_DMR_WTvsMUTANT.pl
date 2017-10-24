#!/usr/bin/perl
use Getopt::Long;
use Data::Dumper;

#################### open folder contains all input files#################
my $USAGE = "\nUSAGE: multiple_DMR_WTvsMUTANT.pl 
                                   -seqdir DMR_folder
                                   -wtlist file containing the list of WT library 
                                   -mulist file containing the list of mutant library 
                                   -Rscript selection scripts for comparision 
                                   ";
my $options = {};
GetOptions($options, "-seqdir=s", "-wtlist=s", "-mulist=s", "Rscript=s"); #, "-out=s" 
die $USAGE unless defined ($options->{seqdir});
die $USAGE unless defined ($options->{wtlist});
die $USAGE unless defined ($options->{mulist});
die $USAGE unless defined ($options->{Rscript});

############################# Grobal Variables #############################
my $seqdir = $options->{seqdir};
my $wtlist = $options->{wtlist};
my $mulist = $options->{mulist};
my $Rscript = $options->{Rscript};

#################### input command ###################################

$user_input = "Rscript  $Rscript ";


opendir (DIR, $seqdir) or die "Couldn't open $seqdir: $!\n";


# obtain the list of WT libraries and save as hash
open (WT,$wtlist);
my %WT_hash;
# my %mutant_hash;
while (<WT>){
    chomp;
    next if (length($_)<1);
    $WT_hash{$_}++;
}

open (MU,$mulist);
my %MU_hash;

while (<MU>){
    chomp;
    next if (length($_)<1);
    $MU_hash{$_}++;
}

$WT_size = keys %WT_hash;
$MU_size = keys %MU_hash;

print "total number of WT libraries: $WT_size , total number of MU libraries: $MU_size , \n";


# $nameDIR = "/u/home/j/jxzhai/SCRATCH/ALL_log/";
$nameDIR = $seqdir;
opendir (NAMEDIR, $nameDIR) or die "Couldn't open $nameDIR: $!\n";

while (defined(my $seqfile = readdir(NAMEDIR))) {
    next if (($seqfile =~ m/^\.$/) or ($seqfile =~ m/^\.\.$/));
    next if !($seqfile =~ m/100\.gz$/);
    # next if !($seqfile =~ m/\.BSMAP_log$/);
    $seqfile =~ m/(\S+?)\./;
    $name = $1;
    $name =~ s/#\d+//;
    next if (!(exists($WT_hash{$name})) && !(exists($MU_hash{$name})));
    $hash{$name} ++;    
}

my @name_array;

foreach my $key (sort keys %hash) {
   push @name_array, $key;
   #print "$key\n";
}

my $count_command =0;
my $command="";
while (my $current = shift @name_array) {
#    print "$current\n";
#    $n1 ++;
    $n2 = 0;
    foreach $remain (@name_array) {
        next if (exists($WT_hash{$current}) && exists($WT_hash{$remain}));
        next if (exists($MU_hash{$current}) && exists($MU_hash{$remain}));
        next if (!(exists($WT_hash{$current})) && !(exists($WT_hash{$remain})));
        next if (!(exists($MU_hash{$current})) && !(exists($MU_hash{$remain})));
        # print "$current\t$remain\n";die;
        $n1++;
        $n2++;
        $count_command++;

    		system("$user_input  $current $remain $seqdir");

    }
}
system("$user_input  $current $remain $seqdir");




