import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  String getDateFormatted(DateTime dateTime) {
    final DateFormat formatter = DateFormat("dd/MM/yyyy hh:mm:ss");
    return formatter.format(dateTime);
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
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          getDateFormatted(blogPost.dateTime),
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      initialValue: blogPost.title,
                      readOnly: true,
                      enabled: false,
                      maxLines: null,
                    ),
                    TextFormField(
                      initialValue: blogPost.content,
                      readOnly: true,
                      enabled: false,
                      maxLines: null,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
