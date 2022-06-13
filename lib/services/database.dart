import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/services/api_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Database {
  // CREATE , UPDATE , DELETE
  Future<void> createBlogPost(BlogPost blogPostData);

  // READ

}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({required this.uid});

  Future<void> createBlogPost(BlogPost blogPostData) async {
    final path = APIPath.BlogPost("blogpost123");
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(blogPostData.toMap());
  }
}
