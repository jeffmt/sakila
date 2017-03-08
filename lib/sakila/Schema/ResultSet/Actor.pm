package sakila::Schema::ResultSet::Actor;
 
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
 
=head2 updated_after
 
A predefined search for recently added actors
 
=cut
 
sub updated_after {
    my ($self, $datetime) = @_;
 
    my $date_str = $self->result_source->schema->storage
                          ->datetime_parser->format_datetime($datetime);
 
    return $self->search({
        last_update => { '>' => $date_str }
    });
}
 
1;
