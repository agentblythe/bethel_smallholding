import 'package:bethel_smallholding/app/sign_in/email_sign_in_page.dart';
import 'package:bethel_smallholding/app/sign_in/sign_in_bloc.dart';
import 'package:bethel_smallholding/app/sign_in/sign_in_button.dart';
import 'package:bethel_smallholding/app/sign_in/sign_in_button_with_text_and_icon.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;

  const SignInPage({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(
            auth: auth,
            isLoading: isLoading,
          ),
          child: Consumer<SignInBloc>(
            builder: (_, bloc, __) => SignInPage(bloc: bloc),
          ),
        ),
      ),
    );

    // return Provider<SignInBloc>(
    //   create: (_) => SignInBloc(auth: auth),
    //   dispose: (_, bloc) => bloc.dispose(),
    //   child: Consumer<SignInBloc>(
    //     builder: (_, bloc, __) => SignInPage(bloc: bloc),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bethel Smallholding'),
        elevation: 2.0,
      ),
      body: _buildContent(
        context,
        isLoading.value,
      ),
      // body: StreamBuilder<bool>(
      //   stream: bloc.isLoadingStream,
      //   initialData: false,
      //   builder: (context, snapshot) {
      //     return _buildContent(context, snapshot.data!);
      //   },
      // ),
      backgroundColor: Colors.grey[200],
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == "SIGN_IN_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: "Sign in failed",
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(isLoading),
          ),
          const SizedBox(
            height: 48,
          ),
          SignInButtonWithTextAndIcon(
            image: "images/google-logo.png",
            text: "Sign in with Google",
            buttonColor: Colors.white,
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButtonWithTextAndIcon(
            image: "images/facebook-logo.png",
            text: "Sign in with Facebook",
            buttonColor: const Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButtonWithTextAndIcon(
            image: "images/email-icon.png",
            text: "Sign in with Email",
            buttonColor: Colors.teal.shade700,
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "or...",
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: "Go Anonymous",
            buttonColor: Colors.lime.shade300,
            textColor: Colors.black,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return const Text(
        "Sign in",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
