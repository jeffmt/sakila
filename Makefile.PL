#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'sakila';
all_from 'lib/sakila.pm';

requires 'Catalyst::Runtime' => '5.90101';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'HTML::FormFu';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'HTML::FormFu::Model::DBIC';
requires 'HTML::FormHandler::Model::DBIC';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::StatusMessage';
requires 'CatalystX::SimpleLogin';
requires 'DBIx::Class::PassphraseColumn';
requires 'DBIx::Class::TimeStamp';
requires 'Template::Plugin::Date';
requires 'Catalyst::Model::DBIC::Schema';
requires 'CatalystX::Component::Traits';
requires 'HTML::FormFu::MultiForm';
requires 'MooseX::Traits::Pluggable';
requires 'Test::WWW::Mechanize::Catalyst';
requires 'Test::Pod::Coverage';

requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
