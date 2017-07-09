package sakila::Controller::Films;
use Moose;
use namespace::autoclean;
use sakila::Form::Film;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

sakila::Controller::Films - Catalyst Controller

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
 
Common logic to start chained dispatch
 
=cut

sub base :Chained('/login/not_required') :PathPart('films') :CaptureArgs(0) {
    my ($self, $c) = @_;
 
    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Film'));
}

=head2 authbase

=cut

sub authbase :Chained('/login/required') :PathPart('films') :CaptureArgs(0) {
    my ($self, $c) = @_;
 
    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Film'));
}

=head2 object

Fetch the specified film object based on the film ID and store
it in the stash. Chain off authbase as changes to specific film requires login.

=cut
sub object :Chained('authbase') :PathPart('id') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(object => $c->stash->{resultset}->find($id));

    die "Film $id not found!" if !$c->stash->{object};
}

=head2 edit

=cut

sub edit : Chained('object') : PathPart('edit'): Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{msg} = "Film updated";

    return $self->form($c, $c->stash->{object});
}

=head2 create

=cut

sub create : Chained('authbase') : PathPart('create'): Args(0) {
    my ( $self, $c ) = @_;

    my $film = $c->stash->{resultset}->new_result({});

    $c->stash->{msg} = sprintf("Film created");

    return $self->form($c, $film);
}

=head2 form 

=cut

sub form {
    my ( $self, $c, $film ) = @_;
    
    my $form = sakila::Form::Film->new;

    $c->stash(template => 'films/form.tt2', form => $form );

    $form->process( item => $film, params => $c->req->params );

    return unless $form->validated;

    # Set a status message for the user & return to films list
    $c->response->redirect($c->uri_for($self->action_for('list'), {status_msg => $c->stash->{msg}}));
}

=head2 list

=cut

sub list : Chained('base') : PathPart('list'): Args(0) {
    my ( $self, $c ) = @_;

    # Limit what the user can order by
    my %valid_order_by = (title => '', rental_rate => '');
    my $order_by = ( defined $c->req->params->{order_by} && exists $valid_order_by{$c->req->params->{order_by}} ) ? $c->req->params->{order_by} 
                 :                                                                                          'title'
                 ;

    # set default page
    my $page = $c->req->param('page') || 1;
    $page = 1 if ( $page !~ /^\d+$/ );
    $page = 1 if ( $page < 1 );

    # set default rows per page
    my $rows = $c->req->param('rows') || 50;
    $rows = 50 if ( $rows !~ /^\d+$/ );
    $rows = 50 if ( $rows < 1 );

    my $result = $c->stash->{resultset}->search({}, {order_by => $order_by, rows => $rows, page => $page});

    my $pager = $result->pager;
    
    # if page is greater last page, set page to last page 
    $result = $result->page($pager->last_page) if $page > $pager->last_page;

    $c->stash(films=>[ $result->all() ]);
    $c->stash(order_by=>$order_by);
    $c->stash(pager=>$pager);
    $c->stash(template=>'films/list.tt2');
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
