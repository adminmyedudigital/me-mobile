import 'package:flutter/material.dart';
import 'package:me_mobile/widgets/widgets.dart';

class MEPasswordField extends StatefulWidget {
  const MEPasswordField({
    super.key,
    this.controller,
    this.labelText = 'Password',
    this.hintText,
    this.prefixIcon,
    this.focusNode,
    this.validator,
    this.autovalidateMode,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.autofillHints,
    this.validateOnBlur = true,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final bool validateOnBlur;

  @override
  State<MEPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<MEPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return METextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      focusNode: widget.focusNode,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      obscureText: _obscureText,
      autofillHints: widget.autofillHints,
      validateOnBlur: widget.validateOnBlur,
      suffixIcon: IconButton(
        tooltip: _obscureText ? 'Show password' : 'Hide password',
        onPressed: widget.enabled
            ? () {
                setState(() => _obscureText = !_obscureText);
              }
            : null,
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}
