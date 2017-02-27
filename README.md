# Sakila web application

This is a basic CRUD application implemented using Catalyst.  It uses
DBIx::Class to access a MySQL sample database named 'sakila' that was 
downloaded from the [MySQL site](https://dev.mysql.com/doc/index-other.html) 
and included in this repository. The database has tables of movies, movie stars, customers and many others
that one would expect to see in a movie rental system.

This application features pages that list the movies, movie stars and 
customers of the rental system, as well as functionality to add, edit and delete them.

# Setup

1. download and install [VirtualBox](https://www.virtualbox.org)
2. download and install [Vagrant](https://www.vagrantup.com)
3. download and extract or use [Git](https://git-scm.com) to clone this repository to your computer
4. type `cd sakila`, followed by `vagrant up` and wait for the message `done`
5. point your browser to http://localhost:3000 to view the application

# Notes

The left sidebar will have links to the login, logout, movie, movie star and customer pages.

You will not see the links to or be able to access the logout and customer pages without logging in.  You will also
not be able to add or edit movies, or add, edit or delete movie stars without logging in.  You will be redirected to the login page 
if you try to perform these actions not logged in.

To login, click the 'Staff Login' link and use the username 'Mike' or 'Jon' and the password 'secretpassword'.  Once logged
in, you will see the 'Staff Login' link replaced by a greeting.

To add movies and movie stars, click the 'Add...' link at the top of the page.

To edit movies and movie stars, click the movie title or movie star's name for that record.

To delete a movie star, click the 'Delete' link on the right of the record row.  The 'Delete' link will not show if the movie star stars in any movies, so you must first edit the record and deselect his/her movies beforehand.  

The functionality to delete movies has not been implemented yet.

The listing of movies, movie stars and customers can be sorted by clicking on a clickable column header.

# Author
Jeff T
