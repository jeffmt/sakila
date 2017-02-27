use utf8;
package sakila::Schema::Result::SaleByStore;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

sakila::Schema::Result::SaleByStore - VIEW

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

=head1 TABLE: C<sales_by_store>

=cut

__PACKAGE__->table("sales_by_store");

=head1 ACCESSORS

=head2 store

  data_type: 'varchar'
  is_nullable: 1
  size: 101

=head2 manager

  data_type: 'varchar'
  is_nullable: 1
  size: 91

=head2 total_sales

  data_type: 'decimal'
  is_nullable: 1
  size: [27,2]

=cut

__PACKAGE__->add_columns(
  "store",
  { data_type => "varchar", is_nullable => 1, size => 101 },
  "manager",
  { data_type => "varchar", is_nullable => 1, size => 91 },
  "total_sales",
  { data_type => "decimal", is_nullable => 1, size => [27, 2] },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-02-13 22:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5eQdHetLa5GU1wK9LZg/Cg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
