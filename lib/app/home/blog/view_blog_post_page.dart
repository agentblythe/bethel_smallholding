import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewBlogPostPage extends StatelessWidget {
  final BlogPost blogPost;
  final Database database;

  const ViewBlogPostPage({
    Key? key,
    required this.blogPost,
    required this.database,
  }) : super(key: key);

  static Future<void> show(BuildContext context, BlogPost blogPost) async {
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) {
          return ViewBlogPostPage(
            blogPost: blogPost,
            database: database,
          );
        }),
        fullscreenDialog: true,
      ),
    );
  }

  String getDateFormatted(DateTime dateTime) {
    final DateFormat formatter = DateFormat("dd/MM/yyyy hh:mm:ss");
    return formatter.format(dateTime);
  }

  Widget _buildImagesView(List<String> imageUrls) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            child: Image.network(
              imageUrls[index],
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                    child: child,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BlogPost>(
        stream: database.blogPostStream(blogPostId: blogPost.id),
        builder: (context, snapshot) {
          // Get the data from the snapshot
          final post = snapshot.data;
          final dateTime = post?.dateTime ?? DateTime.now();
          final title = post?.title ?? "";
          final content = post?.content ?? "";
          final imageUrls = post?.imageUrls ?? [];

          // Build the widget
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
                                getDateFormatted(dateTime),
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            key: UniqueKey(),
                            initialValue: title,
                            readOnly: true,
                            enabled: false,
                            maxLines: null,
                          ),
                          TextFormField(
                            key: UniqueKey(),
                            initialValue: content,
                            readOnly: true,
                            enabled: false,
                            maxLines: null,
                          ),
                          if (imageUrls.isNotEmpty) _buildImagesView(imageUrls),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
