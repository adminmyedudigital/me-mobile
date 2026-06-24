import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/routes/app_routes.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  static const double _fieldGap = 25;
  static const double _buttonGap = 50;

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

  void _submit() {
    setState(() => _submitted = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
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
              MEValidators.minLength(3, fieldName: 'Username'),
              MEValidators.maxLength(30, fieldName: 'Username'),
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
              MEValidators.minLength(8, fieldName: 'Password'),
              MEValidators.maxLength(64, fieldName: 'Password'),
            ]),
          ),
          const SizedBox(height: _buttonGap),
          MEButton(
            label: 'Sign In',
            onPressed: _submit,
            fullWidth: true,
            icon: Icons.login,
            backgroundColor: context.colors.accentGreenGlow,
            foregroundColor: context.colors.charcoal,
          ),
        ],
      ),
    );
  }
}
