use utf8;
package sakila::Schema::Result::SaleByFilmCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

sakila::Schema::Result::SaleByFilmCategory - VIEW

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

=head1 TABLE: C<sales_by_film_category>

=cut

__PACKAGE__->table("sales_by_film_category");

=head1 ACCESSORS

=head2 category

  data_type: 'varchar'
  is_nullable: 0
  size: 25

=head2 total_sales

  data_type: 'decimal'
  is_nullable: 1
  size: [27,2]

=cut

__PACKAGE__->add_columns(
  "category",
  { data_type => "varchar", is_nullable => 0, size => 25 },
  "total_sales",
  { data_type => "decimal", is_nullable => 1, size => [27, 2] },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-02-13 22:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BDQqr0mpar0BQJNdqYQEfQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
