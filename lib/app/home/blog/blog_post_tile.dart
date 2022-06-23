import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:flutter/material.dart';

class BlogPostTile extends StatelessWidget {
  final BlogPost blogPost;
  final VoidCallback onTap;

  const BlogPostTile({
    Key? key,
    required this.blogPost,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(blogPost.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
