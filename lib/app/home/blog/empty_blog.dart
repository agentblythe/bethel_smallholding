import 'package:flutter/material.dart';

class EmptyBlog extends StatelessWidget {
  final String title;
  final String message;

  const EmptyBlog(
      {Key? key,
      this.title = "Nothing here!",
      this.message = "There are no blog posts yet"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black54,
            ),
          ),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
