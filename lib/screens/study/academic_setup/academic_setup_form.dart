import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/screens/study/academic_setup/academic_schedule_notice.dart';

class AcademicSetupScreen extends StatefulWidget {
  const AcademicSetupScreen({super.key});

  @override
  State<AcademicSetupScreen> createState() => _AcademicSetupScreenState();
}

class _AcademicSetupScreenState extends State<AcademicSetupScreen> {
  static const double _fieldGap = 18;
  static const List<MEDropdownOption<int>> _monthOptions = [
    MEDropdownOption(value: 1, label: 'January'),
    MEDropdownOption(value: 2, label: 'February'),
    MEDropdownOption(value: 3, label: 'March'),
    MEDropdownOption(value: 4, label: 'April'),
    MEDropdownOption(value: 5, label: 'May'),
    MEDropdownOption(value: 6, label: 'June'),
    MEDropdownOption(value: 7, label: 'July'),
    MEDropdownOption(value: 8, label: 'August'),
    MEDropdownOption(value: 9, label: 'September'),
    MEDropdownOption(value: 10, label: 'October'),
    MEDropdownOption(value: 11, label: 'November'),
    MEDropdownOption(value: 12, label: 'December'),
  ];
  final _formKey = GlobalKey<FormState>();
  late final AcademicSetupController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AcademicSetupController>();
    _controller.loadAcademicHistory();
  }

  FormFieldValidator<int> _requiredMonth(String fieldName) {
    return (value) {
      if (value == null) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  FormFieldValidator<String> _requiredSelection(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  void _submit() {
    _controller.markSubmitted();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_controller.save()) {
      return;
    }

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Academic setup updated'),
        backgroundColor: context.colors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AcademicSetupController>(
      builder: (controller) {
        final colors = context.colors;
        final canSelectAcademicEnd = controller.canSelectAcademicEnd;
        final autovalidateMode = controller.submitted
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction;
        final educationBoardOptions = controller.educationBoards
            .map(
              (board) => MEDropdownOption(
                value: board.id,
                label:
                    '${board.shortName.toUpperCase()} (${board.coreLanguage.capitalize})',
              ),
            )
            .toList();
        final classOptions = controller.academicClasses
            .map(
              (academicClass) => MEDropdownOption(
                value: academicClass.id,
                label: '${academicClass.academicClass.capitalize}',
              ),
            )
            .toList();
        final startYearOptions = controller.startYears
            .map((year) => MEDropdownOption(value: year, label: '$year'))
            .toList();
        final endYearOptions = controller.endYears
            .map((year) => MEDropdownOption(value: year, label: '$year'))
            .toList();
        final endMonths = controller.endMonths.toSet();
        final endMonthOptions = _monthOptions
            .where((option) => endMonths.contains(option.value))
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Academic Setup')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const AcademicScheduleNotice(),
                  const SizedBox(height: AppSpacing.xl),
                  MEDropdownField<String>(
                    items: educationBoardOptions,
                    initialValue: controller.educationBoardId,
                    labelText: 'Education Board',
                    hintText: 'Education Board',
                    prefixIcon: const Icon(Icons.workspace_premium_outlined),
                    autovalidateMode: autovalidateMode,
                    validator: _requiredSelection('Education board'),
                    onChanged: controller.selectEducationBoard,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEDropdownField<String>(
                    key: ValueKey(controller.educationBoardId),
                    items: classOptions,
                    initialValue: controller.academicClassId,
                    labelText: 'Class',
                    hintText: 'Class',
                    prefixIcon: const Icon(Icons.class_outlined),
                    autovalidateMode: autovalidateMode,
                    validator: _requiredSelection('Class'),
                    onChanged: controller.selectAcademicClass,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEDropdownField<int>(
                    items: _monthOptions,
                    initialValue: controller.academicStartMonth,
                    labelText: 'Academic Start Month',
                    hintText: 'Academic Start Month',
                    prefixIcon: const Icon(Icons.event_available_outlined),
                    autovalidateMode: autovalidateMode,
                    validator: _requiredMonth('Academic start month'),
                    onChanged: controller.selectAcademicStartMonth,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEDropdownField<int>(
                    items: startYearOptions,
                    initialValue: controller.academicStartYear,
                    labelText: 'Academic Start Year',
                    hintText: 'Academic Start Year',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    autovalidateMode: autovalidateMode,
                    validator: _requiredMonth('Academic start year'),
                    onChanged: controller.selectAcademicStartYear,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEDropdownField<int>(
                    key: ValueKey(
                      '${controller.academicStartMonth}_${controller.academicStartYear}_${controller.academicEndYear}',
                    ),
                    items: endMonthOptions,
                    initialValue: controller.academicEndMonth,
                    enabled: canSelectAcademicEnd,
                    labelText: 'Academic End Month',
                    hintText: 'Academic End Month',
                    prefixIcon: const Icon(Icons.event_busy_outlined),
                    autovalidateMode: autovalidateMode,
                    validator: canSelectAcademicEnd
                        ? _requiredMonth('Academic end month')
                        : null,
                    onChanged: controller.selectAcademicEndMonth,
                  ),
                  const SizedBox(height: _fieldGap),
                  MEDropdownField<int>(
                    key: ValueKey(controller.academicStartYear),
                    items: endYearOptions,
                    initialValue: controller.academicEndYear,
                    enabled: canSelectAcademicEnd,
                    labelText: 'Academic End Year',
                    hintText: 'Academic End Year',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    autovalidateMode: autovalidateMode,
                    validator: canSelectAcademicEnd
                        ? _requiredMonth('Academic end year')
                        : null,
                    onChanged: controller.selectAcademicEndYear,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  MEButton(
                    label: 'Save Data',
                    onPressed: _submit,
                    fullWidth: true,
                    icon: Icons.save_outlined,
                    backgroundColor: colors.accentOrange,
                    foregroundColor: colors.ink,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
