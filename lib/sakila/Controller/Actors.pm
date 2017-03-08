package sakila::Controller::Actors;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

sakila::Controller::Actors - Catalyst Controller

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
 
sub base :Chained('/login/not_required') :PathPart('actors') :CaptureArgs(0) {
    my ($self, $c) = @_;
 
    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Actor'));

    $c->load_status_msgs;
}

=head2 authbase
 
=cut
 
sub authbase :Chained('/login/required') :PathPart('actors') :CaptureArgs(0) {
    my ($self, $c) = @_;
 
    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('DB::Actor'));
 
    $c->load_status_msgs;
}

=head2 list

=cut

sub list :Chained('base') :PathPart('list'): Args(0) {
    my ( $self, $c ) = @_;

    # Limit what the user can sort by
    my %valid_order_by = (first_name => '', last_name => '');
    my $order_by = ( defined $c->req->params->{sort} && exists $valid_order_by{$c->req->params->{sort}} ) ? $c->req->params->{sort} 
                 :                                                                                          'last_name'
                 ;

    $c->stash(actors=>[$c->stash->{resultset}->search({}, {order_by => $order_by})]);
    $c->stash(template=>'actors/list.tt2');
}

=head2 object
 
Fetch the specified actor object based on the actor ID and store
it in the stash. Chain off authbase as changes to specific actor requires login.
 
=cut

sub object :Chained('authbase') :PathPart('id') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;
 
    # Find the actor object and store it in the stash
    $c->stash(object => $c->stash->{resultset}->find($id));
 
    die "Actor $id not found!" if !$c->stash->{object};
}

=head2 delete
 
Delete a actor
 
=cut
 
sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;
 
    my $actor_name = $c->stash->{object}->full_name;

    # Use the actor object saved by 'object' and delete it
    $c->stash->{object}->delete;
 
    # Redirect the user back to the list page
    $c->response->redirect(
      $c->uri_for(
        $self->action_for('list'), 
        {
          message_id => $c->set_status_msg("Deleted actor '$actor_name'")
        }
      )
    );
}

=head2 create
 
create a new actor
 
=cut
 
sub create :Chained('authbase') :PathPart('create') :Args(0) :FormConfig('actors/formfu_create.yml') {
    my ($self, $c) = @_;
 
    # Get the form that the :FormConfig attribute saved in the stash
    my $form = $c->stash->{form};
 
    # Check if the form has been submitted (vs. displaying the initial
    # form) and if the data passed validation.  "submitted_and_valid"
    # is shorthand for "$form->submitted && !$form->has_errors"
    if ($form->submitted_and_valid) {
        # Create a new actor
        my $actor = $c->stash->{resultset}->new_result({});
        
        # Save the form data for the actor
        $form->model->update($actor);

        my $actor_name = $actor->full_name;

        # Set a status message for the user & return to actors list
        $c->response->redirect(
          $c->uri_for(
            $self->action_for('list'),
            {
              message_id => $c->set_status_msg("Actor '$actor_name' created")
            }
          )
        );

        $c->detach;
    } else {
        # Get the films from the DB
        my @film_objs = $c->model("DB::Film")->all();

        # Create an array of arrayrefs where each arrayref is an film
        my @films = map { [$_->film_id, $_->title] } sort {$a->title cmp $b->title} @film_objs;

        # Get the select added by the config file
        my $select = $form->get_element({type => 'Select'});

        # Add the films to it
        $select->options(\@films);
    }
 
    # Set the template
    $c->stash(template => 'actors/formfu_create.tt2');
}

=head2 edit
 
Use HTML::FormFu to update an existing actor
 
=cut
 
sub edit :Chained('object') :PathPart('edit') :Args(0) 
        :FormConfig('actors/formfu_create.yml') {
    my ($self, $c) = @_;
 
    # Get the specified actor already saved by the 'object' method
    my $actor = $c->stash->{object};
    my $actor_name = $actor->full_name;
 
    # Make sure we were able to get a actor
    unless ($actor) {
        # Set an error message for the user & return to actors list
        $c->response->redirect(
          $c->uri_for(
            $self->action_for('list'),
            {
              message_id => $c->set_status_msg("Actor not found")
            }
          )
        );

        $c->detach;
    }
 
    # Get the form that the :FormConfig attribute saved in the stash
    my $form = $c->stash->{form};
 
    # Check if the form has been submitted (vs. displaying the initial
    # form) and if the data passed validation.  "submitted_and_valid"
    # is shorthand for "$form->submitted && !$form->has_errors"
    if ($form->submitted_and_valid) {
        # Save the form data for the actor
        $form->model->update($actor);

        # Set a status message for the user & return to actors list
        $c->response->redirect(
          $c->uri_for(
            $self->action_for('list'),
            {
              message_id => $c->set_status_msg("Actor '$actor_name' updated")
            }
          )
        );

        $c->detach;
    } else {
        # Get the films from the DB
        my @film_objs = $c->model("DB::Film")->all();
        # Create an array of arrayrefs where each arrayref is an film
        my @films;
        foreach (sort {$a->title cmp $b->title} @film_objs) {
            push(@films, [$_->film_id, $_->title]);
        }
        # Get the select added by the config file
        my $select = $form->get_element({type => 'Select'});
        # Add the films to it
        $select->options(\@films);
        # Populate the form with existing values from DB
        $form->model->default_values($actor);
    }
 
    # Set the template
    $c->stash(template => 'actors/formfu_create.tt2');
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
