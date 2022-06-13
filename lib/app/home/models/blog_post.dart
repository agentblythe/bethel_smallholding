class BlogPost {
  BlogPost({
    required this.title,
    required this.content,
  });
  final String title;
  final String content;

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
    };
  }
}
