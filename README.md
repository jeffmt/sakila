# Sakila web application

This is a basic CRUD application implemented using Catalyst.  It uses
DBIx::Class to access a MySQL sample database named 'sakila' that was 
downloaded from the [MySQL site](https://dev.mysql.com/doc/index-other.html) and included in this repository.  
The database has tables of movies, movie stars, customers and other
tables one would expect to see in a movie rental system.

This application features pages that list the movies, movie stars and 
customers of the rental business, as well as pages to add & edit movies and add, edit & delete 
movie stars.  Viewing the rental customers and modifications to movies and 
movie stars does require login.

# Setup

1. download and install [VirtualBox](https://www.virtualbox.org)
2. download and install [Vagrant](https://www.vagrantup.com)
3. download and extract or use [Git](https://git-scm.com) to clone this repository to your computer
4. type `cd sakila` followed by `vagrant up`
5. point your browser to http://localhost:3000 to view the application

# Notes

To login to the application, click the 'Staff Login' link and use the
username 'Mike' or 'Jon' and the password 'secretpassword'.  You will
need to be logged in to access the Customers page, and to perform creation,
 modification and deletion of movies and movie stars.

# Author
Jeff T
