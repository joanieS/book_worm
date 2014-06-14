$(document).ready(function() {
  $("button#read").on("click", function(e){
    $.getScript("/preview", function(e){
      $("#myModal").modal('toggle', function(){});
    });
  });
  $("button#next").on("click", function(e){
      $.getScript("/preview", function(e){});
  });
  $("button#like").on("click", function(e){
      $.getScript("/like");
      $.getScript("/preview", function(e) {});
  });
  $("button#dislike").on("click", function(e){
      $.getScript("/dislike");
      $.getScript("/preview", function(e) {});
  });
});

