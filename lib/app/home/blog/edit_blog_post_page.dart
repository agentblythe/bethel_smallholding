import 'dart:io';

import 'package:bethel_smallholding/app/home/blog/blog_post_model.dart';
import 'package:bethel_smallholding/app/home/models/blog_post.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/database.dart';
import 'package:bethel_smallholding/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditBlogPostPage extends StatefulWidget {
  final Database database;
  BlogPostModel model;
  final BlogPost? blogPost;

  EditBlogPostPage({
    Key? key,
    required this.database,
    required this.model,
    this.blogPost,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {BlogPost? blogPost}) async {
    // This context is the one which knows about Database as it is sent
    // from the Blog Page.  The way navigation to this page worked is that
    // a new material route was added to the Material App and as such
    // this widget cannot access the database because database is not in
    // the widget tree at MaterialApp level
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider<BlogPostModel>(
            create: (_) => BlogPostModel(
              id: blogPost?.id ?? "",
              title: blogPost?.title ?? "",
              content: blogPost?.content ?? "",
              imageUrls: blogPost?.imageUrls ?? [],
            ),
            child: Consumer<BlogPostModel>(
              builder: (_, model, __) {
                return EditBlogPostPage(
                  database: database,
                  model: model,
                  blogPost: blogPost,
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
  State<EditBlogPostPage> createState() => _EditBlogPostPageState();
}

class _EditBlogPostPageState extends State<EditBlogPostPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  BlogPostModel get model => widget.model;

  List<String> localImageUrls = [];

  Future<void> _submitForm() async {
    model.updateWith(submittedTapped: true, submitting: true);

    if (_validateAndSaveForm()) {
      if (localImageUrls.isNotEmpty) {
        //var storageService = StorageService.instance;
        //FirebaseStorage _storage = FirebaseStorage.instance;

        for (var localImageUrl in localImageUrls) {
          var remoteURL = await widget.database.putFile(localImageUrl);
          model.addImageUrl(remoteURL);

          //String id = const Uuid().v4();
          //Reference reference = _storage.ref().child("blog_post_images/$id");
          //var file = File(localImageUrl);
          //await reference.putFile(file);
          //var url = await reference.getDownloadURL();
          //model.addImageUrl(url);
        }
      }

      final blogPost = BlogPost(
        id: model.getID(),
        title: model.title,
        content: model.content,
        imageUrls: model.imageUrls,
        dateTime: DateTime.now(),
      );

      try {
        // Code to reject duplicate Blog Post Titles
        // // Gets the first (most up to date) value on the stream
        // final blogPosts = await widget.database.blogPostsStream().first;
        // final allTitles = blogPosts.map((blogPost) => blogPost.title).toList();
        // if (allTitles.contains(blogPost.title)) {
        //   showAlertDialog(
        //     context,
        //     title: "Blog Post Title already in use",
        //     content: "Please choose a different Blog Post Title",
        //     defaultAction: AlertAction(
        //       text: "OK",
        //     ),
        //   );
        //} else {
        await widget.database.setBlogPost(blogPost);
        Navigator.of(context).pop();
        //}
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Operation Failed",
          exception: e,
        );
      } finally {
        model.updateWith(submitting: false);
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
        title: Text(
          widget.blogPost == null ? "Add Blog Post" : "Edit Blog Post",
        ),
        bottom: model.submitting
            ? const PreferredSize(
                child: LinearProgressIndicator(),
                preferredSize: Size.fromHeight(6.0),
              )
            : null,
        elevation: 2.0,
        actions: [
          Visibility(
            child: TextButton(
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: _submitForm,
            ),
            visible: model.submitEnabled,
          ),
        ],
      ),
      body: _buildContents(),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed:
                  model.submitting ? null : () => _getImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
            ),
            IconButton(
              onPressed: model.submitting
                  ? null
                  : () => _getImage(ImageSource.gallery),
              icon: const Icon(Icons.image),
            ),
            if (widget.blogPost != null)
              IconButton(
                onPressed: model.submitting ? null : () {},
                icon: const Icon(Icons.delete),
                color: Colors.red[600],
              ),
          ],
        ),
      ],
      backgroundColor: Colors.grey[200],
    );
  }

  void _getImage(ImageSource source) async {
    XFile? file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (file != null) {
      setState(() {
        localImageUrls.add(file.path);
      });
    }
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
        children: _buildChildren(),
      ),
    );
  }

  List<String> get _images =>
      widget.blogPost == null ? localImageUrls : widget.blogPost!.imageUrls;

  List<Widget> _buildChildren() {
    return [
      _buildTitleTextField(),
      _buildContentTextField(),
      if (_images.isNotEmpty) _buildImagesField(),
    ];
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Blog Post Title",
        errorText: model.titleErrorText,
        enabled: !model.submitting,
      ),
      initialValue: model.title,
      focusNode: _titleFocusNode,
      maxLines: null,
      validator: (_) => model.titleErrorText,
      textInputAction: TextInputAction.next,
      onChanged: model.updateTitle,
      onEditingComplete: _titleEditingComplete,
    );
  }

  Widget _buildContentTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Blog Post Content",
        errorText: model.contentErrorText,
        enabled: !model.submitting,
      ),
      initialValue: model.content,
      focusNode: _contentFocusNode,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      validator: (_) => model.contentErrorText,
      textInputAction: TextInputAction.newline,
      onChanged: model.updateContent,
      onEditingComplete: _contentEditingComplete,
    );
  }

  Widget _buildImagesField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              alignment: Alignment.center,
              child: widget.blogPost == null
                  ? Image.file(
                      File(localImageUrls[index]),
                    )
                  : Image.network(
                      widget.blogPost!.imageUrls[index],
                    ),
            ),
          );
        },
      ),
    );
  }

  void _titleEditingComplete() {
    model.titleNextTapped();

    var newFocus = _titleFocusNode;
    if (model.titleValidator.isValid(model.title)) {
      newFocus = _contentFocusNode;
    } else {
      newFocus = _titleFocusNode;
    }
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _contentEditingComplete() {
    model.contentDoneTapped();
  }
}
