#!/usr/bin/perl
 
use strict;
use warnings;
 
use sakila;
use sakila::Schema;
 
my $schema = sakila::Schema->connect(sakila->config->{dsn});
 
my @staffs = $schema->resultset('Staff')->all;
 
foreach my $staff (@staffs) {
   $staff->password('secretpassword');
   $staff->update;
}

print "done\n";
