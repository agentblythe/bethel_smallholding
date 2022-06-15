import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/services/api_path.dart';
import 'package:bethel_smallholding/services/firestore_service.dart';

abstract class Database {
  // CREATE , UPDATE , DELETE
  Future<void> createBlogPost(BlogPost blogPostData);

  // READ
  Future<bool> isAdmin(String uid);
  Stream<List<BlogPost>> blogPostsStream();
}

class FirestoreDatabase implements Database {
  final _service = FireStoreService.instance;

  @override
  Future<void> createBlogPost(BlogPost blogPostData) => _service.setData(
        path: APIPath.BlogPost("test_id_123"),
        data: blogPostData.toMap(),
      );

  @override
  Future<bool> isAdmin(String uid) async {
    var data = await _service.getCollection(path: APIPath.AdminUsers);
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
        path: APIPath.BlogPosts,
        builder: (data) => BlogPost.fromMap(data),
      );
}
