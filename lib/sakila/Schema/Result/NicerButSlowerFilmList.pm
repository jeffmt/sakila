use utf8;
package sakila::Schema::Result::NicerButSlowerFilmList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

sakila::Schema::Result::NicerButSlowerFilmList - VIEW

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
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<nicer_but_slower_film_list>

=cut

__PACKAGE__->table("nicer_but_slower_film_list");

=head1 ACCESSORS

=head2 fid

  data_type: 'smallint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 category

  data_type: 'varchar'
  is_nullable: 0
  size: 25

=head2 price

  data_type: 'decimal'
  default_value: 4.99
  is_nullable: 1
  size: [4,2]

=head2 length

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 rating

  data_type: 'enum'
  default_value: 'G'
  extra: {list => ["G","PG","PG-13","R","NC-17"]}
  is_nullable: 1

=head2 actors

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "fid",
  {
    data_type => "smallint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "category",
  { data_type => "varchar", is_nullable => 0, size => 25 },
  "price",
  {
    data_type => "decimal",
    default_value => 4.99,
    is_nullable => 1,
    size => [4, 2],
  },
  "length",
  { data_type => "smallint", extra => { unsigned => 1 }, is_nullable => 1 },
  "rating",
  {
    data_type => "enum",
    default_value => "G",
    extra => { list => ["G", "PG", "PG-13", "R", "NC-17"] },
    is_nullable => 1,
  },
  "actors",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-02-13 22:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QpDfSpanBqmJw6q6lrsamA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
