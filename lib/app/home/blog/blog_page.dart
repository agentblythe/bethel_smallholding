import 'package:bethel_smallholding/app/home/blog/edit_blog_post_page.dart';
import 'package:bethel_smallholding/app/home/blog/blog_post_tile.dart';
import 'package:bethel_smallholding/app/home/blog/list_items_builder.dart';
import 'package:bethel_smallholding/app/home/blog/view_blog_post_page.dart';
import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/common_widgets/show_alert_dialog.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:bethel_smallholding/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      debugPrint("Sign-out failed with exception: ${e.toString()}");
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: "Sign out confirmation",
      content: "Are you sure you want to sign out?",
      defaultAction: AlertAction(text: "Sign out", destructive: true),
      cancelAction: AlertAction(text: "Cancel"),
    );

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return FutureBuilder(
      future: database.isAdmin(auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: _blogTitle,
              elevation: 2.0,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: _blogTitle,
              elevation: 2.0,
              actions: <Widget>[
                TextButton(
                  onPressed: () => _confirmSignOut(context),
                  child: const Text(
                    "Sign out",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            body: _buildContents(context, snapshot.data == true),
            floatingActionButton: Visibility(
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => EditBlogPostPage.show(context),
              ),
              visible: snapshot.data == true,
            ),
          );
        }
      },
    );
  }

  Widget get _blogTitle => const Text("Blog");

  Widget _buildBlogPostTile(
      BuildContext context, BlogPost blogPost, bool isAdmin) {
    return BlogPostTile(
      blogPost: blogPost,
      onTap: () => ViewBlogPostPage.show(context, blogPost),
      onLongPress: () =>
          isAdmin ? EditBlogPostPage.show(context, blogPost: blogPost) : null,
    );
  }

  Widget _buildContents(BuildContext context, bool isAdmin) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<BlogPost>>(
      stream: database.blogPostsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<BlogPost>(
          snapshot: snapshot,
          itemBuilder: (context, blogPost) {
            if (isAdmin) {
              return Dismissible(
                key: Key("blogPost-${blogPost.id}"),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _delete(context, blogPost),
                child: _buildBlogPostTile(context, blogPost, isAdmin),
              );
            } else {
              return _buildBlogPostTile(context, blogPost, isAdmin);
            }
          },
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, BlogPost blogPost) async {
    try {
      final db = Provider.of<Database>(context, listen: false);
      await db.deleteBlogPost(blogPost);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Operation Failed",
        exception: e,
      );
    }
  }
}
