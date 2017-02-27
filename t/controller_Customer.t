use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst 'sakila';
use Catalyst::Test 'sakila';

ok( request('/customer/list')->is_redirect, 'Request should get redirected' );
ok( request('/customer')->is_redirect, 'Request should get redirected' );
ok( request('/customer/nonexistant')->is_error, 'Request should fail' );
ok( request('/customer/list/nonexistant')->is_error, 'Request should fail' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'sakila');
$mech->get_ok('/customer/list');

# should not get to list of customers without logging in.  Should get redirected to staff login page
$mech->content_lacks('First Name');
$mech->content_lacks('Last Name');
$mech->content_lacks('Logout');

$mech->content_contains('Staff Login');
$mech->content_contains('Username');
$mech->content_contains('Password');

# log in
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'secretpassword',
    },
  }
);

# should be greeted with 'Hi Mike' after logging in
$mech->content_contains('Hi');
$mech->content_contains('Mike');

# should be past login page and get to list of customers
$mech->content_lacks('Username');
$mech->content_lacks('Password');

$mech->content_contains('First Name');
$mech->content_contains('Last Name');
$mech->content_contains('Email');
$mech->content_contains('Logout');
$mech->content_contains('Customers');

# sorts ok by first and last name and email
$mech->get_ok('/customer/list?sort=first_name');
$mech->get_ok('/customer/list?sort=last_name');
$mech->get_ok('/customer/list?sort=email');

done_testing();
