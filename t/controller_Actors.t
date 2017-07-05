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

my $page_X_of_X_regex = qr/Page\s(\d+)\sof\s\g{-1}\D/;
my $page_1_of_X_regex = qr/Page\s1\sof\s\d+\D/;
my $page_N_of_M_regex = qr/Page\s(\d+)\sof\s(\d+)\D/;

ok( request('/actors/list')->is_success, 'Request should succeed' );
ok( request('/actors')->is_redirect, 'Request should get redirected' );
ok( request('/actors/nonexistant')->is_error, 'Request should fail' );
ok( request('/actors/list/nonexistant')->is_error, 'Request should fail' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'sakila');
$mech->get_ok('/actors/list');

like($mech->uri(), qr/actors\/list/, "At actors listing page");
# check that you are at list of movie stars
$mech->title_is('Movie Stars');
$mech->text_contains('Staff Login');

# check that you are not logged in
$mech->text_lacks('Logout');

$mech->get_ok( '/actors/create' );

# trying to add actor gets redirected to login
$mech->title_is('Staff Login');
$mech->text_contains('You need to login to view this page!');
$mech->text_contains('Username');
$mech->text_contains('Password');

# login
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# successfully logged in
$mech->text_contains('Logout Mike');

# successfully got to add actor page
$mech->title_is('Create/Update Actor');

# try to create new actor
$mech->click_ok('submit', "Fail to create new actor without required first and last name");

# should not be able to add new actor since last and first name are required
$mech->text_contains('This field is required');

my $first_name = rand_string();

# try to create new actor
$mech->field('first_name', $first_name);
$mech->click_ok('submit', "Fail to create new actor without required last name");

# should not be able to add new actor since last name are required
$mech->text_contains('This field is required');

my $last_name = rand_string();

# add a new actor
$mech->field('first_name', $first_name);
$mech->field('last_name', $last_name);
$mech->click_ok('submit', "Create new actor");

# check that a new actor was created
$mech->text_contains("Actor '$first_name $last_name' created");

while (!($mech->find_link( text => $first_name ) && $mech->find_link( text => $last_name ))) {
  $mech->follow_link_ok({text => 'Next >'});
}

# edit the new actor
$mech->follow_link_ok({text => $first_name});

my $new_first_name = rand_string();

# set actor first name to a different name
$mech->field('first_name', $new_first_name);
$mech->field('last_name', $last_name);
$mech->click_ok('submit', "Update actor");

# check that actor was updated
$mech->text_contains("Actor '$first_name $last_name' updated");

while (!($mech->find_link( text => $new_first_name ) && $mech->find_link( text => $last_name ))) {
  $mech->follow_link_ok({text => 'Next >'});
}

# delete new actor just created
my @delete_links = $mech->find_all_links( text => 'Delete' );
for my $delete_link (@delete_links) {

  while (!$mech->find_link( url => $delete_link->url())) {
    $mech->follow_link_ok({text => 'Next >'});
  }

  $mech->follow_link_ok( { url => $delete_link->url() } );

  # check that actor was deleted
  $mech->text_contains("Deleted actor");
}

my $found_actor = 0;

my $current_page_text;
do {
  $found_actor = 1 if ($mech->find_link( text => $new_first_name ) && $mech->find_link( text => $last_name ));
  $current_page_text = $mech->text();
  $mech->follow_link_ok({text => 'Next >'});
} while (!$found_actor && $current_page_text !~ /page (\d+) of \g{-1}/i);

# check that actor we deleted no longer shows in list 
is($found_actor, 0, "Actor deleted");

# Test skip forward and back features
$mech->follow_link_ok({text => 'Last >>'});

$mech->text_like($page_X_of_X_regex);

$mech->follow_link_ok({text => 'Next >'});

$mech->text_like($page_X_of_X_regex);

$mech->follow_link_ok({text => 'Skip Forward 5 >'});

$mech->text_like($page_X_of_X_regex);

if ($mech->text =~ /$page_X_of_X_regex/) {
  my $last_page = $1;
  my $expected_page = $last_page - 5;
  $expected_page = 1 if $expected_page < 1;

  $mech->follow_link_ok({text => '< Skip Back 5'});

  $mech->text_like(qr/Page\s$expected_page\sof\s$last_page/);
}

$mech->follow_link_ok({text => '<< First'});

$mech->text_like($page_1_of_X_regex);

$mech->follow_link_ok({text => '< Previous'});

$mech->text_like($page_1_of_X_regex);

$mech->follow_link_ok({text => '< Skip Back 5'});

$mech->text_like($page_1_of_X_regex);

if ($mech->text =~ /$page_N_of_M_regex/) {
  my $current_page = $1;
  my $last_page = $2;

  $mech->follow_link_ok({text => 'Skip Forward 5 >'});

  my $expected_page = $current_page + 5;
  $expected_page = $last_page if $expected_page > $last_page;

  $mech->text_like(qr/Page\s$expected_page\sof\s$last_page/);

  $mech->follow_link_ok({text => 'Next >'});

  $expected_page++;
  $expected_page = $last_page if $expected_page > $last_page;

  $mech->text_like(qr/Page\s$expected_page\sof\s$last_page/);

  $mech->follow_link_ok({text => '< Previous'});

  $expected_page--;

  $mech->text_like(qr/Page\s$expected_page\sof\s$last_page/);
}

done_testing();
