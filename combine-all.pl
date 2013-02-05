#!/usr/bin/perl

use strict;
use JSON;
use Data::Dumper;
use LWP::Simple;
use URI::Escape;


my $tolerance = '0.001';

#my $wmc = 'http://mapit.mysociety.org/areas/WMC';
#my $mptable = 'http://www.c4em.org.uk/mps-table/?format=json';
#my $data = get($wmc);
#my $mpdata = get($mptable);

my $wmc = 'WMC.json';
my $mptable = 'mp-table.json';
open F, $wmc;
my $data = join('', (<F>));
close F;
open F, $mptable;
my $mpdata = join('', (<F>));
close F;

my $json = JSON->new->allow_nonref;

my $all = $json->decode($data);
my $mps = $json->decode($mpdata);

my $list = $$mps{mps};
my %consthash;
foreach my $one (@$list) {
	$consthash{$one->{constituency}} = $one;
}

open COMBINED, ">combined.js";
print COMBINED 'var statesData = {"type":"FeatureCollection","features":[' . "\n";
my $c = 0;
foreach my $area ( sort { $a <=> $b } keys %$all ) {
	$c++;
	my $name = $$all{$area}->{name};
	print "$area,$name\n";
	my $file = "data/$area.geojson";

	open F, "$file";
	my $poly = join('', (<F>));
	close F;

	$consthash{$name}->{quote} =~ s/"/\\"/g;
	if ($poly ne '') {
		if ($c != 1) {
			print COMBINED ',';
		}
		$consthash{$name}->{quote} =~ s/’/'/;
		print COMBINED '{"type":"Feature","id":"' . $c . '","properties":
		{"name":"' . $name . 
		'", "likelyvote":"' . $consthash{$name}->{likelyvote} . 
		'", "firstname":"' . $consthash{$name}->{firstname} . 
		'", "secondname":"' . $consthash{$name}->{secondname} . 
		'", "party":"' . $consthash{$name}->{party} . 
		'", "evidence":' . $json->encode($consthash{$name}->{evidence}) . 
		', "url":"' . $consthash{$name}->{url} . 
		'", "quote":' . $json->encode($consthash{$name}->{quote}). 
		', "twitter":"' . $consthash{$name}->{twitter} . 
		'"},"geometry":';
		print COMBINED $poly;
		print COMBINED "}\n";
	}
}
print COMBINED "]};\n";
close COMBINED;
