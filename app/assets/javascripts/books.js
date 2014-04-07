function incrementPostLikeCount(post_id,post_likes_count){
  $("#like_post_"+post_id +" span.count").html(post_likes_count);
};