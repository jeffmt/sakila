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

ok( request('/films/list')->is_success, 'Request should succeed' );
ok( request('/films')->is_redirect, 'Request should get redirected' );
ok( request('/films/nonexistant')->is_error, 'Request should fail' );
ok( request('/films/list/nonexistant')->is_error, 'Request should fail' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'sakila');
$mech->get_ok('/films/list');
$mech->get_ok('/films/list?sort=title');
$mech->get_ok('/films/list?sort=rental_rate');

$mech->title_is('Movies');
$mech->content_contains('Staff Login');
$mech->content_lacks('Logout');

$mech->follow_link_ok({text => 'Add a Movie'});

# trying to add movie gets redirected to login
$mech->title_is('Staff Login');
$mech->content_contains('You need to login to view this page!');
$mech->content_contains('Username');
$mech->content_contains('Password');

# login
$mech->submit_form_ok({
    fields => {
      username => 'Jon',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# successfully logged in, and greeted with 'Hi Jon'
$mech->content_contains('Hi');
$mech->content_contains('Jon');

# successfully got to add movie page
$mech->title_is('Create/Update Movie');

# fail to add new movie since title, rental rate and description field are required
$mech->submit();
$mech->content_contains('Title field is required');
$mech->content_contains('Description field is required');
$mech->content_contains('Rental rate field is required');

my $title = rand_string();

$mech->field('title', $title);
$mech->submit();

# fail to add new movie since rental rate and description field are required
$mech->content_lacks('Title field is required');
$mech->content_contains('Description field is required');
$mech->content_contains('Rental rate field is required');

my $description = rand_string();
$mech->field('title', $title);
$mech->field('description', $description);
$mech->submit();

# fail to add new movie since rental rate field is required
$mech->content_lacks('Title field is required');
$mech->content_lacks('Description field is required');
$mech->content_contains('Rental rate field is required');

$mech->submit_form_ok({
    fields => {
      title => $title,
      description => $description,
      rental_rate => '7.99',
    },
  }
);

# successfully created new movie, which should be in list of movies
$mech->title_is('Movies');
$mech->content_contains('Film created.');
$mech->content_contains($title);
$mech->content_contains($description);
$mech->content_contains('7.99');

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
$mech->content_contains('Film updated.');
$mech->content_contains($new_title);
$mech->content_contains($new_description);
$mech->content_contains('8.99');

done_testing();
