use utf8;
package sakila::Schema::Result::Film;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

sakila::Schema::Result::Film

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<film>

=cut

__PACKAGE__->table("film");

=head1 ACCESSORS

=head2 film_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 release_year

  data_type: 'year'
  is_nullable: 1

=head2 language_id

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 original_language_id

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 rental_duration

  data_type: 'tinyint'
  default_value: 3
  extra: {unsigned => 1}
  is_nullable: 0

=head2 rental_rate

  data_type: 'decimal'
  default_value: 4.99
  is_nullable: 0
  size: [4,2]

=head2 length

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 replacement_cost

  data_type: 'decimal'
  default_value: 19.99
  is_nullable: 0
  size: [5,2]

=head2 rating

  data_type: 'enum'
  default_value: 'G'
  extra: {list => ["G","PG","PG-13","R","NC-17"]}
  is_nullable: 1

=head2 special_features

  data_type: 'set'
  extra: {list => ["Trailers","Commentaries","Deleted Scenes","Behind the Scenes"]}
  is_nullable: 1

=head2 last_update

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "film_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "release_year",
  { data_type => "year", is_nullable => 1 },
  "language_id",
  {
    data_type => "tinyint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "original_language_id",
  {
    data_type => "tinyint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "rental_duration",
  {
    data_type => "tinyint",
    default_value => 3,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "rental_rate",
  {
    data_type => "decimal",
    default_value => 4.99,
    is_nullable => 0,
    size => [4, 2],
  },
  "length",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 1 },
  "replacement_cost",
  {
    data_type => "decimal",
    default_value => 19.99,
    is_nullable => 0,
    size => [5, 2],
  },
  "rating",
  {
    data_type => "enum",
    default_value => "G",
    extra => { list => ["G", "PG", "PG-13", "R", "NC-17"] },
    is_nullable => 1,
  },
  "special_features",
  {
    data_type => "set",
    extra => {
      list => [
        "Trailers",
        "Commentaries",
        "Deleted Scenes",
        "Behind the Scenes",
      ],
    },
    is_nullable => 1,
  },
  "last_update",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</film_id>

=back

=cut

__PACKAGE__->set_primary_key("film_id");

=head1 RELATIONS

=head2 film_actors

Type: has_many

Related object: L<sakila::Schema::Result::FilmActor>

=cut

__PACKAGE__->has_many(
  "film_actors",
  "sakila::Schema::Result::FilmActor",
  { "foreign.film_id" => "self.film_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 film_categories

Type: has_many

Related object: L<sakila::Schema::Result::FilmCategory>

=cut

__PACKAGE__->has_many(
  "film_categories",
  "sakila::Schema::Result::FilmCategory",
  { "foreign.film_id" => "self.film_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 inventories

Type: has_many

Related object: L<sakila::Schema::Result::Inventory>

=cut

__PACKAGE__->has_many(
  "inventories",
  "sakila::Schema::Result::Inventory",
  { "foreign.film_id" => "self.film_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 language

Type: belongs_to

Related object: L<sakila::Schema::Result::Language>

=cut

__PACKAGE__->belongs_to(
  "language",
  "sakila::Schema::Result::Language",
  { language_id => "language_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "CASCADE" },
);

=head2 original_language

Type: belongs_to

Related object: L<sakila::Schema::Result::Language>

=cut

__PACKAGE__->belongs_to(
  "original_language",
  "sakila::Schema::Result::Language",
  { language_id => "original_language_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-02-13 22:22:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZUmvoDo6IHaoe+TjkinUIQ

=head2 actors

Type: many_to_many

Related object: L<sakila::Schema::Result::Actor>

=cut

__PACKAGE__->many_to_many(
  actors => 'film_actors',
  'actor',
);

=head1 METHODS

=head2 actors_list

Return comma-separated string of actors that stars in a film

=cut

sub actors_list {
  my ($self) = @_;

  my @actors;
  foreach my $actor ($self->actors) {
    push @actors, $actor->full_name; 
  }

  return join(', ', @actors);
}

=head2 actors_count

Return number of actors that stars in a film

=cut

sub actors_count {
  my ($self) = @_;

  return $self->actors->count;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
