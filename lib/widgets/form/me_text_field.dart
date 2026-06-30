import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:me_mobile/theme/theme.dart';

class METextField extends StatefulWidget {
  const METextField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.autofillHints,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.validateOnBlur = true,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool validateOnBlur;
  final int? maxLines;
  final int? minLines;

  @override
  State<METextField> createState() => _METextFieldState();
}

class _METextFieldState extends State<METextField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus && widget.validateOnBlur) {
          _fieldKey.currentState?.validate();
        }
      },
      child: TextFormField(
        key: _fieldKey,
        focusNode: widget.focusNode,
        controller: widget.controller,
        initialValue: widget.controller == null ? widget.initialValue : null,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        onTap: widget.onTap,
        autofillHints: widget.autofillHints,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          labelStyle: TextStyle(color: colors.ash),
          prefixIconColor: colors.ash,
          suffixIconColor: colors.ash,
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.input,
            borderSide: BorderSide(color: colors.ash),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.input,
            borderSide: BorderSide(color: colors.ash, width: 1.2),
          ),
          errorStyle: TextStyle(color: colors.accentRed),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.input,
            borderSide: BorderSide(color: colors.accentRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppRadius.input,
            borderSide: BorderSide(color: colors.accentRed, width: 1.2),
          ),
        ),
      ),
    );
  }
}
