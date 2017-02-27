package sakila::Controller::Customer;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

sakila::Controller::Customer - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for($self->action_for('list')));
}

=head2 base

=cut

sub base :Chained('/login/not_required') :PathPart('customer') :CaptureArgs(0) {
    my ($self, $c) = @_; 
 
    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Customer'));
}

=head2 authbase

=cut

sub authbase :Chained('/login/required') :PathPart('customer') :CaptureArgs(0) {
    my ($self, $c) = @_; 
 
    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Customer'));
}

=head2 list

=cut

sub list :Chained('authbase') :PathPart('list'): Args(0) {
    my ( $self, $c ) = @_;

    my %valid_order_by = (first_name => '', last_name => '', email => '');

    my $order_by = ( defined $c->req->params->{sort} && exists $valid_order_by{$c->req->params->{sort}} ) ? $c->req->params->{sort} 
                 :                                                                                          'last_name'
                 ;

    $c->stash(customers=>[$c->stash->{resultset}->search({}, {order_by => $order_by})]);
    $c->stash(template=>'customers/list.tt2');
}

=encoding utf8

=head1 AUTHOR

Jeff T

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
