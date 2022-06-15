class BlogPost {
  BlogPost({
    required this.title,
    required this.content,
    required this.dateTime,
  });
  final String title;
  final String content;
  final DateTime dateTime;

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
      "dateTime": dateTime,
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic>? data) {
    if (data != null) {
      return BlogPost(
        title: data['title'],
        content: data['content'],
        dateTime: DateTime.parse(data["dateTime"].toDate().toString()),
      );
    } else {
      throw ArgumentError('Data is null');
    }
  }
}
