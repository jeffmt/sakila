use utf8;
package sakila::Schema::Result::Rental;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

sakila::Schema::Result::Rental

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

=head1 TABLE: C<rental>

=cut

__PACKAGE__->table("rental");

=head1 ACCESSORS

=head2 rental_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 rental_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 inventory_id

  data_type: 'mediumint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 customer_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 return_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 staff_id

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 last_update

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "rental_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "rental_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "inventory_id",
  {
    data_type => "mediumint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "customer_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "return_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "staff_id",
  {
    data_type => "tinyint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
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

=item * L</rental_id>

=back

=cut

__PACKAGE__->set_primary_key("rental_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<rental_date>

=over 4

=item * L</rental_date>

=item * L</inventory_id>

=item * L</customer_id>

=back

=cut

__PACKAGE__->add_unique_constraint("rental_date", ["rental_date", "inventory_id", "customer_id"]);

=head1 RELATIONS

=head2 customer

Type: belongs_to

Related object: L<sakila::Schema::Result::Customer>

=cut

__PACKAGE__->belongs_to(
  "customer",
  "sakila::Schema::Result::Customer",
  { customer_id => "customer_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "CASCADE" },
);

=head2 inventory

Type: belongs_to

Related object: L<sakila::Schema::Result::Inventory>

=cut

__PACKAGE__->belongs_to(
  "inventory",
  "sakila::Schema::Result::Inventory",
  { inventory_id => "inventory_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "CASCADE" },
);

=head2 payments

Type: has_many

Related object: L<sakila::Schema::Result::Payment>

=cut

__PACKAGE__->has_many(
  "payments",
  "sakila::Schema::Result::Payment",
  { "foreign.rental_id" => "self.rental_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 staff

Type: belongs_to

Related object: L<sakila::Schema::Result::Staff>

=cut

__PACKAGE__->belongs_to(
  "staff",
  "sakila::Schema::Result::Staff",
  { staff_id => "staff_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-02-13 22:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1rzWO71HDzcAW+TTWYCYfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
