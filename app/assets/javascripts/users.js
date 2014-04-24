$(document).ready(function() {

  $("a[href=#register]").click(function(){
    $.getScript("/users/new", function(e){
    });
  });

  $("a[href=#liked]").click(function(){
    $.getScript("/liked_books", function(e){
    });
  });

});