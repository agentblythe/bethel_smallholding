import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/services/api_path.dart';
import 'package:bethel_smallholding/services/firestore_service.dart';

abstract class Database {
  // CREATE , UPDATE , DELETE
  Future<void> setBlogPost(BlogPost blogPostData);

  // READ
  Future<bool> isAdmin(String uid);
  Stream<List<BlogPost>> blogPostsStream();
}

String documentIDFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final _service = FireStoreService.instance;

  @override
  Future<void> setBlogPost(BlogPost blogPostData) async => _service.setData(
        path: APIPath.blogPost(blogPostData.id),
        data: blogPostData.toMap(),
      );

  @override
  Future<bool> isAdmin(String uid) async {
    var data = await _service.getCollection(path: APIPath.adminUsers);
    var docs = data.docs;

    List<String> ids = docs
        .map(
          (doc) => doc.data().values.first.toString(),
        )
        .toList();

    return ids.contains(uid);
  }

  @override
  Stream<List<BlogPost>> blogPostsStream() => _service.collectionStream(
        path: APIPath.blogPosts,
        builder: (data, documentID) => BlogPost.fromMap(data, documentID),
      );
}
