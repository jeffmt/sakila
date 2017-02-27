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
$mech->content_contains('Username');
$mech->content_contains('Password');

# check that you are not logged in
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

# try to login without username and password
$mech->submit_form_ok({
    fields => {
      username => undef,
      password => undef 
    }
  }, 'Logged in'
);

# check that you failed to login without supplying username and password
$mech->content_lacks('Hi');
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

# try to login without password
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => undef 
    }
  }, 'Logged in'
);

# check that you failed to login with a missing password
$mech->content_lacks('Hi');
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

# try to login without username
$mech->submit_form_ok({
    fields => {
      username => undef,
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# check that you failed to login with a missing username 
$mech->content_lacks('Hi');
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

# try to login with a wrong password
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'wrongpassword'
    }
  }, 'Logged in'
);

# check that you failed to login with a wrong password
$mech->content_lacks('Hi');
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

# check that you failed to login with a wrong username
$mech->submit_form_ok({
    fields => {
      username => 'NoOne',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# check that you failed to login with a wrong username
$mech->content_lacks('Hi');
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

# login
$mech->submit_form_ok({
    fields => {
      username => 'Mike',
      password => 'secretpassword'
    }
  }, 'Logged in'
);

# check successfully logged in
$mech->content_contains('Hi');
$mech->content_contains('Mike');
$mech->content_contains('Customers');
$mech->content_contains('Logout');

# logout
$mech->follow_link_ok({text => 'Logout'});

# check successfully logged out
$mech->content_contains('Staff Login');
$mech->content_lacks('Hi');
$mech->content_lacks('Mike');
$mech->content_lacks('Jon');
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

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
$mech->content_contains('Hi');
$mech->content_contains('Jon');
$mech->content_lacks('Mike');
$mech->content_contains('Customers');
$mech->content_contains('Logout');

# logout
$mech->follow_link_ok({text => 'Logout'});

# check successfully logged out
$mech->content_contains('Staff Login');
$mech->content_lacks('Hi');
$mech->content_lacks('Jon');
$mech->content_lacks('Mike');
$mech->content_lacks('Logout');
$mech->content_lacks('Customers');

done_testing();
