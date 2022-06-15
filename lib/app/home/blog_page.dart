import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/common_widgets/show_alert_dialog.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:bethel_smallholding/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatelessWidget {
  BlogPage({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print("Sign-out failed with exception: ${e.toString()}");
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

  Future<void> _createBlogPost(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createBlogPost(
        BlogPost(
          title: "test title",
          content: "test content",
          dateTime: DateTime.now(),
        ),
      );
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Operation Failed",
        exception: e,
      );
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
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: _blogTitle,
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
            body: _buildContents(context),
            floatingActionButton: Visibility(
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
              visible: snapshot.data == true,
            ),
          );
        }
      },
    );
  }

  Widget get _blogTitle => const Text("Blog");

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<BlogPost>>(
      stream: database.blogPostsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final blogPosts = snapshot.data;
          if (blogPosts != null) {
            final children =
                blogPosts.map((blogPost) => Text(blogPost.title)).toList();
            return ListView(
              children: children,
            );
          }
        }
        if (snapshot.hasError) {
          var error = snapshot.error.toString();
          return Center(child: Text("Some error occurred : $error"));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
