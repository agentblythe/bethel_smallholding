import 'package:bethel_smallholding/app/home/blog/add_blog_post_model.dart';
import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBlogPage extends StatefulWidget {
  final Database database;
  AddBlogPostModel model;

  AddBlogPage({
    Key? key,
    required this.database,
    required this.model,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    // This context is the one which knows about Database as it is sent
    // from the Blog Page.  The way navigation to this page worked is that
    // a new material route was added to the Material App and as such
    // this widget cannot access the database because database is not in
    // the widget tree at MaterialApp level
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider<AddBlogPostModel>(
            create: (_) => AddBlogPostModel(),
            child: Consumer<AddBlogPostModel>(
              builder: (_, model, __) {
                return AddBlogPage(
                  database: database,
                  model: model,
                );
              },
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  AddBlogPostModel get model => widget.model;

  Future<void> _submitForm() async {
    model.submit();

    if (_validateAndSaveForm()) {
      final blogPost = BlogPost(
        title: model.title,
        content: model.content,
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
        decoration: InputDecoration(
          labelText: "Blog Post Title",
          errorText: model.titleErrorText,
        ),
        focusNode: _titleFocusNode,
        validator: (_) => model.titleErrorText,
        textInputAction: TextInputAction.next,
        onChanged: model.updateTitle,
        onEditingComplete: _titleEditingComplete,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: "Blog Post Content",
          errorText: model.contentErrorText,
        ),
        focusNode: _contentFocusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        validator: (_) => model.contentErrorText,
        textInputAction: TextInputAction.done,
        onChanged: model.updateContent,
      ),
    ];
  }

  void _titleEditingComplete() {
    final newFocus = model.titleValidator.isValid(model.title)
        ? _contentFocusNode
        : _titleFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
}
