import 'package:flutter/material.dart';

class MEValidators {
  const MEValidators._();

  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> requiredField({
    String fieldName = 'This field',
  }) {
    return (value) {
      if ((value ?? '').trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  static FormFieldValidator<String> minLength(
    int min, {
    String fieldName = 'This field',
  }) {
    return (value) {
      final text = (value ?? '').trim();
      if (text.isNotEmpty && text.length < min) {
        return '$fieldName must be at least $min characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> maxLength(
    int max, {
    String fieldName = 'This field',
  }) {
    return (value) {
      final text = (value ?? '').trim();
      if (text.length > max) {
        return '$fieldName must be at most $max characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> email({String fieldName = 'Email'}) {
    return (value) {
      final text = (value ?? '').trim();
      if (text.isEmpty) {
        return null;
      }

      final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
      if (!isValid) {
        return 'Enter a valid ${fieldName.toLowerCase()}';
      }
      return null;
    };
  }

  static FormFieldValidator<String> phone({String fieldName = 'Phone number'}) {
    return (value) {
      final text = (value ?? '').trim();
      if (text.isEmpty) {
        return null;
      }

      final digits = text.replaceAll(RegExp(r'\D'), '');
      if (digits.length != 10) {
        return '$fieldName must be 10 digits';
      }
      return null;
    };
  }
}
