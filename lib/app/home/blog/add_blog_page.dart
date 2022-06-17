import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBlogPage extends StatefulWidget {
  final Database database;

  const AddBlogPage({
    Key? key,
    required this.database,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    // This context is the one which knows about Database as it is sent
    // from the Blog Page
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBlogPage(
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  String? _content;

  Future<void> _submitForm() async {
    if (_validateAndSaveForm()) {
      final blogPost = BlogPost(
        title: _title!,
        content: _content!,
        dateTime: DateTime.now(),
      );

      try {
        await widget.database.createBlogPost(blogPost);

        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Operation Failed",
          exception: e,
        );
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Blog Post"),
        elevation: 2.0,
        actions: [
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: "Blog Post Title"),
        onSaved: (value) => _title = value,
        validator: (value) {
          return (value == null || value.isEmpty)
              ? "Title can't be empty"
              : null;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: "Blog Post Content"),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onSaved: (value) => _content = value,
        validator: (value) {
          return (value == null || value.isEmpty)
              ? "Content can't be empty"
              : null;
        },
      ),
    ];
  }
}
