$(document).ready(function() {
  $(".primary-nav a").removeClass("active");

  var current_location = $(location).attr('pathname');

  if ( current_location == '/actors/list') {
    $("#movie-stars").addClass("active");
  }
  else if ( current_location == '/films/list') {
    $("#movies").addClass("active");
  }
  else if ( current_location == '/customer/list') {
    $("#customers").addClass("active");
  }
  else if ( current_location == '/login') {
    $("#login").addClass("active");
  }
  else if ( current_location == '/films/create') {
    if ($(".mobile-menu-icon").css("display") == "none") {
      $("#movies").addClass("active");
    }
    else {
      $("#add-movie").addClass("active");
    }
  }
  else if ( current_location == '/actors/create') {
    if ($(".mobile-menu-icon").css("display") == "none") {
      $("#movie-stars").addClass("active");
    }
    else {
      $("#add-movie-star").addClass("active");
    }
  }

  $(".mobile-menu-icon").on("click", function() {
    $(".primary-nav").toggleClass("focused");
    $(this).toggleClass("open");
  });
});
