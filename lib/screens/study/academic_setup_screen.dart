import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

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
  static const List<MEDropdownOption<int>> _yearOptions = [
    MEDropdownOption(value: 2025, label: '2025'),
    MEDropdownOption(value: 2026, label: '2026'),
    MEDropdownOption(value: 2027, label: '2027'),
    MEDropdownOption(value: 2028, label: '2028'),
    MEDropdownOption(value: 2029, label: '2029'),
    MEDropdownOption(value: 2030, label: '2030'),
    MEDropdownOption(value: 2031, label: '2031'),
    MEDropdownOption(value: 2032, label: '2032'),
    MEDropdownOption(value: 2033, label: '2033'),
    MEDropdownOption(value: 2034, label: '2034'),
    MEDropdownOption(value: 2035, label: '2035'),
  ];

  final _formKey = GlobalKey<FormState>();

  late final List<EducationBoardModel> _educationBoards;
  String? _educationBoard;
  String? _className;
  int? _academicStartMonth;
  int? _academicStartYear;
  int? _academicEndMonth;
  int? _academicEndYear;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _educationBoards = _authEducationBoards();
    final settings = Get.find<AppController>().studySettings.value;
    _educationBoard = _dropdownValueOrNull(
      _educationBoardOptions,
      settings.educationBoard,
    );
    _className = _dropdownValueOrNull(_classOptions, settings.className);
    _academicStartMonth = settings.academicStartMonth;
    _academicStartYear = settings.academicStartYear;
    _academicEndMonth = settings.academicEndMonth;
    _academicEndYear = settings.academicEndYear;
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

  List<MEDropdownOption<String>> get _educationBoardOptions {
    return _educationBoards
        .map(
          (board) => MEDropdownOption(
            value: board.id,
            label:
                '${board.shortName.toUpperCase()} (${board.coreLanguage.capitalize})',
          ),
        )
        .toList();
  }

  List<MEDropdownOption<int>> get _startYearOptions {
    final currentYear = DateTime.now().year;

    return [
      MEDropdownOption(value: currentYear, label: '$currentYear'),
      MEDropdownOption(value: currentYear + 1, label: '${currentYear + 1}'),
    ];
  }

  List<MEDropdownOption<String>> get _classOptions {
    final selectedBoard = _educationBoards.where(
      (board) => board.id == _educationBoard,
    );

    if (selectedBoard.isEmpty) {
      return const [];
    }

    return selectedBoard.first.academicClasses
        .where((academicClass) => academicClass.id.isNotEmpty)
        .map(
          (academicClass) => MEDropdownOption(
            value: academicClass.id,
            label: '${academicClass.academicClass.capitalize}',
          ),
        )
        .toList();
  }

  List<EducationBoardModel> _authEducationBoards() {
    final boardsById = <String, EducationBoardModel>{};
    final schoolAcademicClasses =
        Get.find<AuthController>().schoolAcademicClasses;

    for (final school in schoolAcademicClasses) {
      for (final board in school.educationBoards) {
        if (board.id.isEmpty) {
          continue;
        }

        final existingBoard = boardsById[board.id];
        boardsById[board.id] = existingBoard == null
            ? board
            : existingBoard.mergeAcademicClasses(board);
      }
    }

    return boardsById.values.toList();
  }

  String? _dropdownValueOrNull(
    List<MEDropdownOption<String>> options,
    String value,
  ) {
    if (value.isEmpty) {
      return null;
    }

    for (final option in options) {
      if (option.value == value) {
        return value;
      }
    }

    return null;
  }

  void _submit() {
    setState(() => _submitted = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final educationBoard = _educationBoard;
    final className = _className;
    final startMonth = _academicStartMonth;
    final startYear = _academicStartYear;
    final endMonth = _academicEndMonth;
    final endYear = _academicEndYear;
    if (educationBoard == null ||
        className == null ||
        startMonth == null ||
        startYear == null ||
        endMonth == null ||
        endYear == null) {
      return;
    }

    final appController = Get.find<AppController>();
    appController.updateStudySettings(
      schoolName: appController.studySettings.value.schoolName,
      educationBoard: educationBoard,
      className: className,
      academicStartMonth: startMonth,
      academicStartYear: startYear,
      academicEndMonth: endMonth,
      academicEndYear: endYear,
    );

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
    final colors = context.colors;
    final canSelectAcademicEnd =
        _academicStartMonth != null && _academicStartYear != null;
    final autovalidateMode = _submitted
        ? AutovalidateMode.always
        : AutovalidateMode.onUserInteraction;

    return Scaffold(
      appBar: AppBar(title: const Text('Academic Setup')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                'Academic setup',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'These details help create a study timetable that matches your school year.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.charcoal,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              MEDropdownField<String>(
                items: _educationBoardOptions,
                initialValue: _educationBoard,
                labelText: 'Education Board',
                hintText: 'Education Board',
                prefixIcon: const Icon(Icons.workspace_premium_outlined),
                autovalidateMode: autovalidateMode,
                validator: _requiredSelection('Education board'),
                onChanged: (value) {
                  setState(() {
                    _educationBoard = value;
                    _className = null;
                  });
                },
              ),
              const SizedBox(height: _fieldGap),
              MEDropdownField<String>(
                key: ValueKey(_educationBoard),
                items: _classOptions,
                initialValue: _className,
                labelText: 'Class',
                hintText: 'Class',
                prefixIcon: const Icon(Icons.class_outlined),
                autovalidateMode: autovalidateMode,
                validator: _requiredSelection('Class'),
                onChanged: (value) {
                  setState(() => _className = value);
                },
              ),
              const SizedBox(height: _fieldGap),
              MEDropdownField<int>(
                items: _monthOptions,
                initialValue: _academicStartMonth,
                labelText: 'Academic Start Month',
                hintText: 'Academic Start Month',
                prefixIcon: const Icon(Icons.event_available_outlined),
                autovalidateMode: autovalidateMode,
                validator: _requiredMonth('Academic start month'),
                onChanged: (value) {
                  setState(() => _academicStartMonth = value);
                },
              ),
              const SizedBox(height: _fieldGap),
              MEDropdownField<int>(
                items: _startYearOptions,
                initialValue: _academicStartYear,
                labelText: 'Academic Start Year',
                hintText: 'Academic Start Year',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                autovalidateMode: autovalidateMode,
                validator: _requiredMonth('Academic start year'),
                onChanged: (value) {
                  setState(() => _academicStartYear = value);
                },
              ),
              const SizedBox(height: _fieldGap),
              MEDropdownField<int>(
                items: _monthOptions,
                initialValue: _academicEndMonth,
                enabled: canSelectAcademicEnd,
                labelText: 'Academic End Month',
                hintText: 'Academic End Month',
                prefixIcon: const Icon(Icons.event_busy_outlined),
                autovalidateMode: autovalidateMode,
                validator: canSelectAcademicEnd
                    ? _requiredMonth('Academic end month')
                    : null,
                onChanged: (value) {
                  setState(() => _academicEndMonth = value);
                },
              ),
              const SizedBox(height: _fieldGap),
              MEDropdownField<int>(
                items: _yearOptions,
                initialValue: _academicEndYear,
                enabled: canSelectAcademicEnd,
                labelText: 'Academic End Year',
                hintText: 'Academic End Year',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                autovalidateMode: autovalidateMode,
                validator: canSelectAcademicEnd
                    ? _requiredMonth('Academic end year')
                    : null,
                onChanged: (value) {
                  setState(() => _academicEndYear = value);
                },
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
  }
}
