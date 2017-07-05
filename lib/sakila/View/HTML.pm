package sakila::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        sakila->path_to( 'root', 'src' ),
        sakila->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper.tt2',
    ERROR        => 'error.tt2',
    TIMER        => 0,
    TEMPLATE_EXTENSION => '.tt2',
    render_die   => 1,
});

=head1 NAME

sakila::View::HTML - Catalyst TTSite View

=head1 SYNOPSIS

See L<sakila>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Jeff T

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

