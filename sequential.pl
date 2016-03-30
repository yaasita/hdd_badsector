#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);

my $disk = shift;

my $sector = shift;
for (($sector-100)..($sector+100)){
    check_and_write_sector($_);
}

sub check_and_write_sector {
    my $num = shift;
    say $num;
    my $out;
    $out = `hdparm --read-sector $num $disk`;
    if ($?){
        my $cmd = "hdparm --write-sector $num --yes-i-know-what-i-am-doing $disk";
        say "\t$cmd";
        system "$cmd" and die "$! : $out";
    }
}
