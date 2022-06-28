class BlogPost {
  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.dateTime,
  });
  final String id;
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime dateTime;

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
      "imageUrls": imageUrls,
      "dateTime": dateTime,
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic>? data, String documentID) {
    if (data != null) {
      return BlogPost(
        id: documentID,
        title: data['title'],
        content: data['content'],
        imageUrls: data['imageUrls'].cast<String>(),
        dateTime: DateTime.parse(data["dateTime"].toDate().toString()),
      );
    } else {
      throw ArgumentError('Data is null');
    }
  }
}
