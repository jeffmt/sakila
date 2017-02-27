#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'sakila';

ok( request('/')->is_redirect, 'Request should get redirected' );
ok( request('/nonexistant')->is_error, 'Request should get redirected' );

done_testing();
