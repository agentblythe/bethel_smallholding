import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Database {
  // CREATE , UPDATE , DELETE
  Future<void> createBlogPost(Map<String, dynamic> blogPostData);

  // READ

}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({required this.uid});

  Future<void> createBlogPost(Map<String, dynamic> blogPostData) async {
    final path = "/blog_posts/blogpost123";
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(blogPostData);
  }
}
