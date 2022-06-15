class APIPath {
  static String blogPost(String blogPostID) => "$blogPosts/$blogPostID";
  static String get adminUsers => "/admin_users";
  static String get blogPosts => "/blog_posts";
}
