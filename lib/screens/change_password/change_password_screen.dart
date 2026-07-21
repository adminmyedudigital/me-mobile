import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  static const double _fieldGap = 18;

  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _submitted = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await Get.find<AuthController>().updatePassword(
      UpdatePasswordPayloadModel(
        existingPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
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
        canPop: !Get.find<AuthController>().isUpdatingPassword.value,
        child: Scaffold(
          appBar: AppBar(title: const Text('Password')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Text(
                    'Enter your current password before setting a new one.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.charcoal,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  MEPasswordField(
                    controller: _currentPasswordController,
                    labelText: 'Current Password',
                    hintText: 'Current Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        _newPasswordFocusNode.requestFocus(),
                    autofillHints: const [AutofillHints.password],
                    autovalidateMode: autovalidateMode,
                    validator: _currentPassword,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEPasswordField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    labelText: 'New Password',
                    hintText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_reset),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        _confirmPasswordFocusNode.requestFocus(),
                    autofillHints: const [AutofillHints.newPassword],
                    autovalidateMode: autovalidateMode,
                    validator: _newPassword,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEPasswordField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    labelText: 'Confirm New Password',
                    hintText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    autofillHints: const [AutofillHints.newPassword],
                    autovalidateMode: autovalidateMode,
                    validator: _confirmPassword,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Obx(
                    () => MEButton(
                      label: 'Update Password',
                      onPressed: _submit,
                      isLoading:
                          Get.find<AuthController>().isUpdatingPassword.value,
                      fullWidth: true,
                      icon: Icons.save_outlined,
                      backgroundColor: colors.accentOrange,
                      foregroundColor: colors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _currentPassword(String? value) {
    return MEValidators.compose([
      MEValidators.requiredField(fieldName: 'Current password'),
      MEValidators.minLength(5, fieldName: 'Current password'),
      MEValidators.maxLength(50, fieldName: 'Current password'),
    ])(value);
  }

  String? _newPassword(String? value) {
    return MEValidators.compose([
      MEValidators.requiredField(fieldName: 'New password'),
      MEValidators.minLength(5, fieldName: 'New password'),
      MEValidators.maxLength(50, fieldName: 'New password'),
    ])(value);
  }

  String? _confirmPassword(String? value) {
    final error = MEValidators.compose([
      MEValidators.requiredField(fieldName: 'Confirm new password'),
      MEValidators.minLength(5, fieldName: 'Confirm new password'),
      MEValidators.maxLength(50, fieldName: 'Confirm new password'),
    ])(value);
    if (error != null) {
      return error;
    }

    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }
}
