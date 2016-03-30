#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);

my $disk = shift;
unless ($disk){
    say "usage: smartctl -a /dev/sdx | $0 /dev/sdx";
    exit;
}
my %uniq;
while (<STDIN>){
    if (/SMART Self-test log/../^$/){
        next if /^SMART/;
        if (/\d+$/){
            my $sector = $&;
            next if $uniq{$sector}++;
            check_and_write_sector($sector);
            check_and_write_sector($sector-1) if $sector > 1;
        }
    }
}
sub check_and_write_sector {
    my $num = shift;
    say $num;
    my $out;
    $out = `hdparm --read-sector $& $disk`;
    if ($?){
        my $cmd = "hdparm --write-sector $num --yes-i-know-what-i-am-doing $disk";
        say "\t$cmd";
        system "$cmd" and die "$! : $out";
    }
}
