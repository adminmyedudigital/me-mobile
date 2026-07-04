import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static const double _fieldGap = 25;
  static const double _buttonGap = 50;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _submitted = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final appController = Get.find<AppController>();
    appController.updateProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );
    appController.markAuthenticated();
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
            controller: _firstNameController,
            labelText: 'First Name',
            hintText: 'First Name',
            prefixIcon: const Icon(Icons.person_outline),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (_) => _lastNameFocusNode.requestFocus(),
            autofillHints: const [AutofillHints.givenName],
            autovalidateMode: autovalidateMode,
            validator: MEValidators.compose([
              MEValidators.requiredField(fieldName: 'First name'),
              MEValidators.minLength(2, fieldName: 'First name'),
              MEValidators.maxLength(30, fieldName: 'First name'),
            ]),
          ),
          const SizedBox(height: _fieldGap),
          METextField(
            controller: _lastNameController,
            focusNode: _lastNameFocusNode,
            labelText: 'Last Name',
            hintText: 'Last Name',
            prefixIcon: const Icon(Icons.person_outline),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
            autofillHints: const [AutofillHints.familyName],
            autovalidateMode: autovalidateMode,
            validator: MEValidators.compose([
              MEValidators.requiredField(fieldName: 'Last name'),
              MEValidators.minLength(2, fieldName: 'Last name'),
              MEValidators.maxLength(30, fieldName: 'Last name'),
            ]),
          ),
          const SizedBox(height: _fieldGap),
          METextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            labelText: 'Email',
            hintText: 'Email',
            prefixIcon: const Icon(Icons.mail_outline),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _phoneFocusNode.requestFocus(),
            autofillHints: const [AutofillHints.email],
            autovalidateMode: autovalidateMode,
            validator: MEValidators.compose([
              MEValidators.requiredField(fieldName: 'Email'),
              MEValidators.email(),
              MEValidators.maxLength(80, fieldName: 'Email'),
            ]),
          ),
          const SizedBox(height: _fieldGap),
          METextField(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            labelText: 'Phone Number',
            hintText: 'Phone Number',
            prefixIcon: const Icon(Icons.phone_outlined),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            textInputAction: TextInputAction.next,
            onChanged: _handlePhoneChanged,
            onEditingComplete: () => _usernameFocusNode.requestFocus(),
            onFieldSubmitted: (_) => _usernameFocusNode.requestFocus(),
            autofillHints: const [AutofillHints.telephoneNumber],
            autovalidateMode: autovalidateMode,
            validator: MEValidators.compose([
              MEValidators.requiredField(fieldName: 'Phone number'),
              MEValidators.phone(),
            ]),
          ),
          const SizedBox(height: _fieldGap),
          METextField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            labelText: 'Username',
            hintText: 'Username',
            prefixIcon: const Icon(Icons.alternate_email),
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
            focusNode: _passwordFocusNode,
            labelText: 'Password',
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
            autofillHints: const [AutofillHints.newPassword],
            autovalidateMode: autovalidateMode,
            validator: MEValidators.compose([
              MEValidators.requiredField(fieldName: 'Password'),
              MEValidators.minLength(8, fieldName: 'Password'),
              MEValidators.maxLength(64, fieldName: 'Password'),
            ]),
          ),
          const SizedBox(height: _fieldGap),
          MEPasswordField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            labelText: 'Confirm Password',
            hintText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            autofillHints: const [AutofillHints.newPassword],
            autovalidateMode: autovalidateMode,
            validator: _confirmPassword,
          ),
          const SizedBox(height: _buttonGap),
          MEButton(
            label: 'Create Account',
            onPressed: _submit,
            fullWidth: true,
            icon: Icons.person_add_alt_1,
            backgroundColor: context.colors.accentOrange,
            foregroundColor: context.colors.ink,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  void _handlePhoneChanged(String value) {
    if (value.length == 10) {
      _usernameFocusNode.requestFocus();
    }
  }

  String? _confirmPassword(String? value) {
    final requiredError = MEValidators.requiredField(
      fieldName: 'Confirm password',
    )(value);
    if (requiredError != null) {
      return requiredError;
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
