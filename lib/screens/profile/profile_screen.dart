import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const double _fieldGap = 18;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final profile = Get.find<AppController>().profile.value;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _submitted = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await Get.find<AuthController>().updateProfile(
      UpdateProfilePayloadModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
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
        canPop: !Get.find<AuthController>().isUpdatingProfile.value,
        child: Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Text(
                    'Update your name and contact details.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.charcoal,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                      MEValidators.maxLength(25, fieldName: 'First name'),
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
                      MEValidators.maxLength(25, fieldName: 'Last name'),
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
                      MEValidators.minLength(5, fieldName: 'Email'),
                      MEValidators.email(),
                      MEValidators.maxLength(100, fieldName: 'Email'),
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
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    autofillHints: const [AutofillHints.telephoneNumber],
                    autovalidateMode: autovalidateMode,
                    validator: MEValidators.compose([
                      MEValidators.requiredField(fieldName: 'Phone number'),
                      MEValidators.phone(),
                    ]),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  MEButton(
                    label: 'Save Profile',
                    onPressed: _submit,
                    isLoading:
                        Get.find<AuthController>().isUpdatingProfile.value,
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
}
