import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  static const double _fieldGap = 25;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _submitted = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _submitted = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await Get.find<AuthController>().signIn(
      SignInPayloadModel(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  Future<void> _openForgottenPassword(BuildContext context) async {
    final opened = await launchUrl(
      Uri.parse(ApiRoutes.forgottenPasswordWeb),
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the forgotten password page.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final autovalidateMode = _submitted
        ? AutovalidateMode.always
        : AutovalidateMode.onUserInteraction;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          METextField(
            controller: _usernameController,
            labelText: 'Username',
            hintText: 'Username',
            prefixIcon: const Icon(Icons.person_outline),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
            autofillHints: const [AutofillHints.username],
            autovalidateMode: autovalidateMode,
            validator: MEValidators.compose([
              MEValidators.requiredField(fieldName: 'Username'),
              MEValidators.minLength(5, fieldName: 'Username'),
              MEValidators.maxLength(25, fieldName: 'Username'),
            ]),
          ),
          const SizedBox(height: _fieldGap),
          MEPasswordField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            autovalidateMode: autovalidateMode,
            validator: MEValidators.compose([
              MEValidators.requiredField(fieldName: 'Password'),
              MEValidators.minLength(5, fieldName: 'Password'),
              MEValidators.maxLength(50, fieldName: 'Password'),
            ]),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _openForgottenPassword(context),
              child: Text(
                'Forgotten password',
                style: TextStyle(color: context.colors.primary),
              ),
            ),
          ),
          const SizedBox(height: _fieldGap),
          Obx(() {
            final authController = Get.find<AuthController>();

            return MEButton(
              label: 'Sign In',
              onPressed: _submit,
              isLoading: authController.isSigningIn.value,
              fullWidth: true,
              icon: Icons.login,
              backgroundColor: context.colors.accentOrange,
              foregroundColor: context.colors.ink,
            );
          }),
        ],
      ),
    );
  }
}
