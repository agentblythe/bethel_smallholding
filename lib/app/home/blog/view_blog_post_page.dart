import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Widget _buildImagesView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: blogPost.imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              alignment: Alignment.center,
              child: Image.network(
                blogPost.imageUrls[index],
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          );
        },
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
                    ),
                    if (blogPost.imageUrls.isNotEmpty) _buildImagesView(),
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
