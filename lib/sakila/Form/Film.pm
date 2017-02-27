package sakila::Form::Film;
 
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use namespace::autoclean;
 
has '+item_class' => ( default =>'Films' );
has_field 'title' => ( type => 'Text', required => 1 );
has_field 'description' => ( type => 'Text', size=>150, required => 1 );
has_field 'language' => ( type => 'Select', label_column => 'name' );
has_field 'rental_rate' => ( type => 'Money', required => 1);
has_field 'actors' => ( type => 'Multiple', label_column => 'full_name' );
has_field 'submit' => ( type => 'Submit', value => 'Submit' );
 
__PACKAGE__->meta->make_immutable;
1;
