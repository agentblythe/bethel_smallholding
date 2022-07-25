import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/services/api_path.dart';
import 'package:bethel_smallholding/services/firestore_service.dart';
import 'package:bethel_smallholding/services/storage_service.dart';

abstract class Database {
  // CREATE , UPDATE , DELETE
  Future<void> setBlogPost(BlogPost blogPostData);
  Future<String> putFile(String filePath);
  Future<void> deleteBlogPost(BlogPost blogPost);

  // READ
  Future<bool> isAdmin(String uid);
  Stream<List<BlogPost>> blogPostsStream();
  Stream<BlogPost> blogPostStream({required String blogPostId});
}

String documentIDFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final _service = FireStoreService.instance;
  final _storage = StorageService.instance;

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
  Future<String> putFile(String filePath) async {
    return await _storage.putFile(filePath);
  }

  @override
  Future<void> deleteBlogPost(BlogPost blogPost) {
    var imagePaths = blogPost.imageUrls;
    if (imagePaths.isNotEmpty) {
      for (String path in imagePaths) {
        _storage.deleteFile(path);
      }
    }

    return _service.deleteData(path: APIPath.blogPost(blogPost.id));
  }

  @override
  Stream<List<BlogPost>> blogPostsStream() => _service.collectionStream(
        path: APIPath.blogPosts,
        builder: (data, documentID) => BlogPost.fromMap(data, documentID),
      );

  @override
  Stream<BlogPost> blogPostStream({required String blogPostId}) =>
      _service.documentStream(
        path: APIPath.blogPost(blogPostId),
        builder: (data, documentID) => BlogPost.fromMap(data, documentID),
      );
}
