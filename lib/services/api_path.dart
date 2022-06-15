class APIPath {
  static String BlogPost(String blogPostID) => "$BlogPosts/$blogPostID";
  static String get AdminUsers => "/admin_users";
  static String get BlogPosts => "/blog_posts";
}
