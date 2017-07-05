use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst 'sakila';

use Catalyst::Test 'sakila';

ok( request('/login')->is_success, 'Request should succeed' );

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'sakila');

$mech->get_ok('/login');

# check that you are at login page
$mech->title_is('Staff Login');
$mech->text_contains('Username');
$mech->text_contains('Password');

# check that you are not logged in
$mech->text_lacks('Logout');
$mech->text_lacks('Customers');

# try to login without username and password
$mech->submit_form_ok({
    fields => {
      username => undef,
      password => undef 
    }
  }, 'Logged in'
);

# check that you failed to login without supplying username and password
$mech->text_lacks('Logout');
$mech->text_lacks('Customers');

# try to login without password
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => undef 
    }
  }, 'Logged in'
);

# check that you failed to login with a missing password
$mech->text_lacks('Logout');
$mech->text_lacks('Customers');

# try to login without username
$mech->submit_form_ok({
    fields => {
      username => undef,
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# check that you failed to login with a missing username 
$mech->text_lacks('Logout');
$mech->text_lacks('Customers');

# try to login with a wrong password
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'wrongpassword'
    }
  }, 'Logged in'
);

# check that you failed to login with a wrong password
$mech->text_lacks('Logout');
$mech->text_lacks('Customers');

# check that you failed to login with a wrong username
$mech->submit_form_ok({
    fields => {
      username => 'NoOne',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# check that you failed to login with a wrong username
$mech->text_lacks('Logout');
$mech->text_lacks('Customers');

# login
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# check successfully logged in
$mech->text_contains('Logout Mike');
$mech->text_contains('Customers');

# logout
$mech->follow_link_ok({text => 'Logout Mike'});

# check successfully logged out
$mech->text_contains('Staff Login');
$mech->text_lacks('Logout Mike');
$mech->text_lacks('Logout Jon');
$mech->text_lacks('Customers');

$mech->follow_link_ok({text => 'Staff Login'});

# login using different user
$mech->submit_form_ok({
    fields => {
      username => 'Jon',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# check successfully logged in
$mech->text_contains('Logout Jon');
$mech->text_contains('Customers');
$mech->text_lacks('Mike');
$mech->text_contains('Customers');

# logout
$mech->follow_link_ok({text => 'Logout Jon'});

# check successfully logged out
$mech->text_contains('Staff Login');
$mech->text_lacks('Logout Mike');
$mech->text_lacks('Logout Jon');
$mech->text_lacks('Customers');

done_testing();
