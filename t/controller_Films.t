use strict;
use warnings;
use Test::More;

use Catalyst::Test 'sakila';
use Test::WWW::Mechanize::Catalyst 'sakila';
use sakila::Controller::Films;

sub rand_string {
  my @chars = ("a".."z");
  my $result = "";
  $result .= $chars[int(rand(@chars))] for (0...10);
  return $result;
}

my $page_X_of_X_regex = qr/Page\s(\d+)\sof\s\g{-1}\D/;
my $page_1_of_X_regex = qr/Page\s1\sof\s\d+\D/;
my $page_N_of_M_regex = qr/Page\s(\d+)\sof\s(\d+)\D/;

ok( request('/films/list')->is_success, 'Request should succeed' );
ok( request('/films')->is_redirect, 'Request should get redirected' );
ok( request('/films/nonexistant')->is_error, 'Request should fail' );
ok( request('/films/list/nonexistant')->is_error, 'Request should fail' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'sakila');
$mech->get_ok('/films/list');
$mech->get_ok('/films/list?sort=title');
$mech->get_ok('/films/list?sort=rental_rate');

$mech->title_is('Movies');
$mech->text_contains('Staff Login');
$mech->text_lacks('Logout');

$mech->get_ok( '/films/create' );

# trying to add movie gets redirected to login
$mech->title_is('Staff Login');
$mech->text_contains('You need to login to view this page!');
$mech->text_contains('Username');
$mech->text_contains('Password');

# login
$mech->submit_form_ok({
    fields => {
      username => 'Jon',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# successfully logged in, and greeted with 'Logout Jon'
$mech->text_contains('Logout Jon');

# successfully got to add movie page
$mech->title_is('Create/Update Movie');

# fail to add new movie since title, rental rate and description field are required
$mech->submit();
$mech->text_contains('Title field is required');
$mech->text_contains('Description field is required');
$mech->text_contains('Rental rate field is required');

my $title = rand_string();

$mech->field('title', $title);
$mech->submit();

# fail to add new movie since rental rate and description field are required
$mech->text_lacks('Title field is required');
$mech->text_contains('Description field is required');
$mech->text_contains('Rental rate field is required');

my $description = rand_string();
$mech->field('title', $title);
$mech->field('description', $description);
$mech->submit();

# fail to add new movie since rental rate field is required
$mech->text_lacks('Title field is required');
$mech->text_lacks('Description field is required');
$mech->text_contains('Rental rate field is required');

$mech->submit_form_ok({
    fields => {
      title => $title,
      description => $description,
      rental_rate => '7.99',
    },
  }
);

# check that new movie was created successfully created new movie, which should be in list of movies
$mech->title_is('Movies');
$mech->text_contains("Film created");

# check that new movie shows up in list of movies
while ( !$mech->find_link( text => $title ) ) {
  $mech->follow_link_ok({text => 'Next >'});

  my $page_text = $mech->text();

  last if ($page_text =~ /$page_X_of_X_regex/);
}

ok( $mech->find_link( text => $title ), "Newly created movie exists on movie listing page" );
$mech->text_contains($description);
$mech->text_contains('7.99');

$mech->follow_link_ok({text => $title});

my $new_title = rand_string();
my $new_description = rand_string();

$mech->title_is('Create/Update Movie');

$mech->submit_form_ok({
    fields => {
      title => $new_title,
      description => $new_description,
      rental_rate => '8.99',
    },
  }
);

# successfully updated new movie, which should be in list of movies
$mech->title_is('Movies');
$mech->text_contains('Film updated');

while ( !$mech->find_link( text => $new_title ) ) {
  $mech->follow_link_ok({text => 'Next >'});

  my $page_text = $mech->text();

  last if ($page_text =~ /$page_X_of_X_regex/);
}

$mech->text_contains($new_title);
$mech->text_contains($new_description);
$mech->text_contains('8.99');

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
