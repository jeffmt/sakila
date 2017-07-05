use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst 'sakila';
use Catalyst::Test 'sakila';

my $page_X_of_X_regex = qr/Page\s(\d+)\sof\s\g{-1}\D/;
my $page_1_of_X_regex = qr/Page\s1\sof\s\d+\D/;
my $page_N_of_M_regex = qr/Page\s(\d+)\sof\s(\d+)\D/;

ok( request('/customer/list')->is_redirect, 'Request should get redirected' );
ok( request('/customer')->is_redirect, 'Request should get redirected' );
ok( request('/customer/nonexistant')->is_error, 'Request should fail' );
ok( request('/customer/list/nonexistant')->is_error, 'Request should fail' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'sakila');
$mech->get_ok('/customer/list');

# should not get to list of customers without logging in.  Should get redirected to staff login page
$mech->text_lacks('First Name');
$mech->text_lacks('Last Name');
$mech->text_lacks('Logout');

$mech->text_contains('Staff Login');
$mech->text_contains('Username');
$mech->text_contains('Password');

# log in
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'secretpassword',
    },
  }
);

# should be greeted with 'Logout Mike' after logging in
$mech->text_contains('Logout Mike');

# should be past login page and get to list of customers
$mech->text_lacks('Username');
$mech->text_lacks('Password');

$mech->text_contains('First Name');
$mech->text_contains('Last Name');
$mech->text_contains('Email');
$mech->text_contains('Logout');
$mech->text_contains('Customers');

# sorts ok by first and last name and email
$mech->get_ok('/customer/list?sort=first_name');
$mech->get_ok('/customer/list?sort=last_name');
$mech->get_ok('/customer/list?sort=email');

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
