import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:flutter/material.dart';

class ViewBlogPostPage extends StatelessWidget {
  final BlogPost blogPost;

  const ViewBlogPostPage({
    Key? key,
    required this.blogPost,
  }) : super(key: key);

  static Future<void> show(BuildContext context, BlogPost blogPost) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) {
          return ViewBlogPostPage(blogPost: blogPost);
        }),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bethel Smallholding"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(blogPost.title),
            ],
          ),
        ),
      ),
    );
  }
}
