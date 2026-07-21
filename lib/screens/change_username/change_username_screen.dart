import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class ChangeUsernameScreen extends StatefulWidget {
  const ChangeUsernameScreen({super.key});

  @override
  State<ChangeUsernameScreen> createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  static const double _fieldGap = 18;

  final _formKey = GlobalKey<FormState>();
  final _currentUsernameController = TextEditingController();
  final _newUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _currentUsernameController.text =
        Get.find<AppController>().profile.value.username;
  }

  @override
  void dispose() {
    _currentUsernameController.dispose();
    _newUsernameController.dispose();
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

    await Get.find<AuthController>().updateUsername(
      UpdateUsernamePayloadModel(
        newUsername: _newUsernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final autovalidateMode = _submitted
        ? AutovalidateMode.always
        : AutovalidateMode.onUserInteraction;

    return Obx(
      () => PopScope(
        canPop: !Get.find<AuthController>().isUpdatingUsername.value,
        child: Scaffold(
          appBar: AppBar(title: const Text('Username')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Text(
                    'Choose the username you want to use for sign in.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.charcoal,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  METextField(
                    controller: _currentUsernameController,
                    labelText: 'Current Username',
                    hintText: 'Current Username',
                    prefixIcon: const Icon(Icons.person_pin_rounded),
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    enabled: false,
                  ),
                  const SizedBox(height: _fieldGap),
                  METextField(
                    controller: _newUsernameController,
                    labelText: 'New Username',
                    hintText: 'New Username',
                    prefixIcon: const Icon(Icons.alternate_email),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    autofillHints: const [AutofillHints.newUsername],
                    autovalidateMode: autovalidateMode,
                    validator: _newUsername,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEPasswordField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    labelText: 'Password',
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    autofillHints: const [AutofillHints.password],
                    autovalidateMode: autovalidateMode,
                    validator: _password,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  MEButton(
                    label: 'Update Username',
                    onPressed: _submit,
                    isLoading:
                        Get.find<AuthController>().isUpdatingUsername.value,
                    fullWidth: true,
                    icon: Icons.save_outlined,
                    backgroundColor: colors.accentOrange,
                    foregroundColor: colors.ink,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _newUsername(String? value) {
    final error = MEValidators.compose([
      MEValidators.requiredField(fieldName: 'New username'),
      MEValidators.minLength(5, fieldName: 'New username'),
      MEValidators.maxLength(100, fieldName: 'New username'),
    ])(value);
    if (error != null) {
      return error;
    }

    if (value?.trim() == _currentUsernameController.text.trim()) {
      return 'Enter a different username';
    }

    return null;
  }

  String? _password(String? value) {
    return MEValidators.compose([
      MEValidators.requiredField(fieldName: 'Password'),
      MEValidators.minLength(5, fieldName: 'Password'),
      MEValidators.maxLength(50, fieldName: 'Password'),
    ])(value);
  }
}
