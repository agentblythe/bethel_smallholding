import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:flutter/material.dart';

class BlogPostTile extends StatelessWidget {
  final BlogPost blogPost;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const BlogPostTile({
    Key? key,
    required this.blogPost,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(blogPost.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
