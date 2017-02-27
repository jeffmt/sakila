use strict;
use warnings;
use Test::More;
use WWW::Mechanize;

#use sakila::Controller::Customer;

my $mech = WWW::Mechanize->new();
my $url = "http://localhost:3000//actors/formfu_create";
$mech->get($url);
#$mech->content_lacks('First Name');
#$mech->content_lacks('Last Name');
#$mech->content_contains('Username');
#$mech->content_contains('Password');
#
$mech->field('username', 'Mike');
$mech->field('password', 'secretpassword');
$mech->submit();
my $content = $mech->content;
print $content, "\n";
#
#$mech->content_lacks('Username');
#$mech->content_lacks('Password');
#$mech->content_contains('Hi Mike');
#$mech->content_contains('First Name');
#$mech->content_contains('Last Name');
#
#done_testing();
