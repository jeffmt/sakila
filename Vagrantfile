# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update

    # install package needed to build CPAN modules
    sudo apt-get -qq -y install build-essential

    # install CPANMinus
    sudo apt-get -qq -y install cpanminus

    # install Git
    sudo apt-get -qq -y install git

    # Git clone sakila project
    git clone https://github.com/jeffmt/sakila.git

    # install MySQL
    export DEBIAN_FRONTEND="noninteractive"

    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password rootpw"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password rootpw"

    sudo apt-get -qq -y install mysql-server 

    $ populate MySQL sakila database
    mysql -u root -prootpw < /home/vagrant/sakila/sakila-schema.sql 
    mysql -u root -prootpw < /home/vagrant/sakila/alter_sakila_schema.sql
    mysql -u root -prootpw < /home/vagrant/sakila/sakila-data.sql 

    # install Catalyst Web Framework
    sudo apt-get -qq -y install libcatalyst-perl
    sudo apt-get -qq -y install libcatalyst-modules-perl

    # install CPAN modules
    sudo cpanm --notest --force HTML::FormFu::Model::DBIC HTML::FormHandler::Model::DBIC CatalystX::SimpleLogin DBIx::Class::TimeStamp Catalyst::Plugin::StatusMessage DBIx::Class::PassphraseColumn Catalyst::Model::DBIC::Schema CatalystX::Component::Traits HTML::FormFu::MultiForm MooseX::Traits::Pluggable Test::WWW::Mechanize::Catalyst Test::Pod::Coverage

    sudo cpanm --notest --force --sudo HTML::FormFu::Model::DBIC

    # run script to set passwords in staff table in database
    perl -I/home/vagrant/sakila/lib /home/vagrant/sakila/set_hashed_passwords.pl

    # start Catalyst Web App
    perl -I/home/vagrant/sakila/lib /home/vagrant/sakila/script/sakila_server.pl

  SHELL
end
