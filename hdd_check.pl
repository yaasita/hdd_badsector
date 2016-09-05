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
            $uniq{$sector}++;
        }
    }
}
for (keys %uniq){
    my $n = $_;
    say "start => ",$n;
    my $start = $n - 1000;
    my $end   = $n + 1000;
    $start = 0 if $start < 0;
    for ($start..$end){
        check_and_write_sector($_);
    }
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
