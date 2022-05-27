import 'package:bethel_smallholding/app/sign_in/email_sign_in_bloc.dart';
import 'package:bethel_smallholding/app/sign_in/email_sign_in_model.dart';
import 'package:bethel_smallholding/common_widgets/form_submit_button.dart';
import 'package:bethel_smallholding/common_widgets/show_alert_dialog.dart';
import 'package:bethel_smallholding/common_widgets/show_exception_alert_dialog.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInForm(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Sign in failed",
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _confirmResetPassword(BuildContext context, String email) async {
    final didConfirmResetPassword = await showAlertDialog(
      context,
      title: "Reset password confirmation",
      content:
          "Are you sure you want to reset your password?  An email will be sent to $email",
      defaultAction: AlertAction(
        text: "Reset",
        destructive: true,
      ),
      cancelAction: AlertAction(text: "Cancel"),
    );

    if (didConfirmResetPassword == true) {
      _resetPassword(context, email);
    }
  }

  Future<void> _resetPassword(BuildContext context, String email) async {
    const snackBar = SnackBar(
      content: Text("Reset Password email sent!"),
    );

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print("Password reset failed with exception: ${e.toString()}");
    }
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPasswordTextField(model),
          _passwordVisibilityIcon(model),
        ],
      ),
      const SizedBox(height: 16),
      FormSubmitButton(
        child: !model.isLoading
            ? Text(
                model.primaryButtonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              )
            : const CircularProgressIndicator(),
        callback: model.submitEnabled ? _submit : null,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
      if (model.formType == EmailSignInFormType.signIn)
        TextButton(
          onPressed: model.restPasswordEnabled
              ? () => _confirmResetPassword(context, model.email)
              : null,
          child: const Text("Forgotten your password? Reset it."),
        ),
    ];
  }

  Widget _passwordVisibilityIcon(EmailSignInModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: IconButton(
        onPressed: widget.bloc.togglePasswordVisibility,
        icon: const Icon(
          Icons.remove_red_eye,
        ),
        color: model.hidePassword ? Colors.grey : Colors.blue,
      ),
    );
  }

  Widget _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@test.com",
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
    );
  }

  Widget _buildPasswordTextField(EmailSignInModel model) {
    return Expanded(
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: "Password",
          errorText: model.passwordErrorText,
          enabled: !model.isLoading,
        ),
        obscureText: model.hidePassword,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onEditingComplete: model.submitEnabled ? _submit : null,
        onChanged: widget.bloc.updatePassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(model),
          ),
        );
      },
    );
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
}
