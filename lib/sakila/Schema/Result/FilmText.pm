use utf8;
package sakila::Schema::Result::FilmText;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

sakila::Schema::Result::FilmText

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

=head1 TABLE: C<film_text>

=cut

__PACKAGE__->table("film_text");

=head1 ACCESSORS

=head2 film_id

  data_type: 'smallint'
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "film_id",
  { data_type => "smallint", is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</film_id>

=back

=cut

__PACKAGE__->set_primary_key("film_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-02-13 22:22:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eOOgcpA2bWt/7iB0XHxeGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
