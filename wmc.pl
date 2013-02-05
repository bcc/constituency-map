#!/usr/bin/perl

use strict;
use JSON;
use Data::Dumper;
use LWP::Simple;

my $tolerance = '0.005';

my $wmc = 'http://mapit.mysociety.org/areas/WMC';

my $json = JSON->new->allow_nonref;

my $data = get($wmc);
my $all = $json->decode($data);

foreach my $area ( sort { $a <=> $b } keys %$all ) {
	my $name = $$all{$area}->{name};

	my $geojsonurl = "http://mapit.mysociety.org/area/$area.geojson?simplify_tolerance=$tolerance";
	my $file = "data/$area.geojson";

	if ((stat($file))[7] == 0) {
		print "$area,$name\n";
		my $poly = get($geojsonurl);
		open F, ">$file";
		print F $poly;
		close F;
	}

	sleep 2;
}
