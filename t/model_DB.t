use strict;
use warnings;
use Test::More;

use Catalyst::Test 'sakila';

BEGIN { use_ok 'sakila::Model::DB' }

done_testing();
