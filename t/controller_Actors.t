use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst 'sakila';

use Catalyst::Test 'sakila';
use sakila::Controller::Actors;

sub rand_string {
  my @chars = ("a".."z");
  my $result = "";
  $result .= $chars[int(rand(@chars))] for (0...10);
  return $result;
}

ok( request('/actors/list')->is_success, 'Request should succeed' );
ok( request('/actors')->is_redirect, 'Request should get redirected' );
ok( request('/actors/nonexistant')->is_error, 'Request should fail' );
ok( request('/actors/list/nonexistant')->is_error, 'Request should fail' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'sakila');
$mech->get_ok('/actors/list');

# check that you are at list of movie stars
$mech->title_is('Movie Stars');
$mech->content_contains('Staff Login');

# check that you are not logged in
$mech->content_lacks('Logout');

$mech->follow_link_ok({text => 'Add Actor'});

# trying to add actor gets redirected to login
$mech->title_is('Staff Login');
$mech->content_contains('You need to login to view this page!');
$mech->content_contains('Username');
$mech->content_contains('Password');

# login
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# successfully logged in
$mech->content_contains('Hi');
$mech->content_contains('Mike');
$mech->content_contains('Logout');

# successfully got to add actor page
$mech->title_is('Create/Update Actor');

# try to create new actor
$mech->click_ok('submit', "Fail to create new actor without required first and last name");

# should not be able to add new actor since last and first name are required
$mech->content_contains('This field is required');

my $first_name = rand_string();

# try to create new actor
$mech->field('first_name', $first_name);
$mech->click_ok('submit', "Fail to create new actor without required last name");

# should not be able to add new actor since last name are required
$mech->content_contains('This field is required');

my $last_name = rand_string();

# add a new actor
$mech->field('first_name', $first_name);
$mech->field('last_name', $last_name);
$mech->click_ok('submit', "Create new actor");

# check that a new actor was created
$mech->content_contains('created');
$mech->content_contains("$first_name $last_name");

# edit the new actor
$mech->follow_link_ok({text => $first_name});

my $new_first_name = rand_string();

# set actor first name to a different name
$mech->field('first_name', $new_first_name);
$mech->field('last_name', $last_name);
$mech->click_ok('submit', "Update actor");

# check that actor was updated
$mech->content_contains("$first_name $last_name");
$mech->content_contains('updated');

# delete actors
my @delete_links = $mech->find_all_links( text => 'Delete' );
for my $delete_link (@delete_links) {
  $mech->follow_link_ok( { url => $delete_link->url() } );

  # check that actor was deleted
  $mech->content_contains('Deleted actor');
}

$mech->follow_link_ok({text => 'Movie Stars'});

# check that actor we deleted no longer shows in list 
$mech->content_lacks("$new_first_name $last_name");

done_testing();
