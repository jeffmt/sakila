use utf8;
package sakila::Schema::Result::StaffList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

sakila::Schema::Result::StaffList - VIEW

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

=head1 TABLE: C<staff_list>

=cut

__PACKAGE__->table("staff_list");

=head1 ACCESSORS

=head2 id

  data_type: 'tinyint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 91

=head2 address

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 zip code

  accessor: 'zip_code'
  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 phone

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 city

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 country

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 sid

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "tinyint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 91 },
  "address",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "zip code",
  {
    accessor => "zip_code",
    data_type => "varchar",
    is_nullable => 1,
    size => 10,
  },
  "phone",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "city",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "country",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "sid",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-02-13 22:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:33DW2ALGZ+UrF94M0MxICw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
