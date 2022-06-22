import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:flutter/material.dart';

class BlogPostTile extends StatelessWidget {
  final BlogPost blogPost;

  const BlogPostTile({
    Key? key,
    required this.blogPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(blogPost.title);
  }
}
