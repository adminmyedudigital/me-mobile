import 'package:get/get.dart';

import 'package:me_mobile/utils/utils.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/controllers/api_controller_mixin.dart';

class AcademicSetupController extends GetxController with ApiControllerMixin {
  String? _loadedUserId;
  bool _hasSavedSettings = false;

  AcademicHistoryModel? academicHistory;
  List<EducationBoardModel> educationBoards = const [];

  String? educationBoardId;
  String? academicClassId;
  int? academicStartMonth;
  int? academicStartYear;
  int? academicEndMonth;
  int? academicEndYear;
  bool submitted = false;
  bool isSaving = false;

  bool get hasAcademicHistory => academicHistory != null;
  bool get canSelectAcademicEnd =>
      academicStartMonth != null && academicStartYear != null;

  List<AcademicClassModel> get academicClasses {
    for (final board in educationBoards) {
      if (board.id == educationBoardId) {
        return board.academicClasses
            .where((academicClass) => academicClass.id.isNotEmpty)
            .toList();
      }
    }

    return const [];
  }

  List<int> get startYears {
    final currentYear = DateTime.now().year;
    final years = {currentYear, currentYear + 1};
    final historyStartYear = academicHistory?.startYear;

    if (historyStartYear != null && historyStartYear > 0) {
      years.add(historyStartYear);
    }

    return years.toList()..sort();
  }

  List<int> get endYears {
    final startYear = academicStartYear;

    if (startYear == null) {
      return const [];
    }

    return [startYear, startYear + 1];
  }

  List<int> get endMonths {
    final startMonth = academicStartMonth;
    final startYear = academicStartYear;

    if (startMonth == null || startYear == null) {
      return const [];
    }

    if (academicEndYear == null || academicEndYear == startYear) {
      return [for (var month = startMonth; month <= 12; month++) month];
    }

    return [for (var month = 1; month <= startMonth; month++) month];
  }

  void loadAcademicHistory() {
    final authController = Get.find<AuthController>();
    final userId = authController.currentUser?.id;
    final restoreSavedSettings =
        authController.academicHistory == null &&
        userId != null &&
        userId == _loadedUserId &&
        _hasSavedSettings;

    academicHistory = authController.academicHistory;
    educationBoards = _educationBoardsFromAuth(authController);
    _loadedUserId = userId;

    if (restoreSavedSettings) {
      educationBoardId = _validStringValue(
        educationBoards.map((board) => board.id),
        educationBoardId ?? '',
      );
      academicClassId = _validStringValue(
        academicClasses.map((academicClass) => academicClass.id),
        academicClassId ?? '',
      );
      academicStartMonth = _validIntValue(
        List.generate(12, (index) => index + 1),
        academicStartMonth,
      );
      academicStartYear = _validIntValue(startYears, academicStartYear);
      submitted = false;
      _normalizeAcademicEndSelection();
      update();
      return;
    }

    _hasSavedSettings = false;

    educationBoardId = _validStringValue(
      educationBoards.map((board) => board.id),
      academicHistory?.educationBoardId ?? '',
    );
    academicClassId = _validStringValue(
      academicClasses.map((academicClass) => academicClass.id),
      academicHistory?.academicClassId ?? '',
    );
    academicStartMonth = _validIntValue(
      List.generate(12, (index) => index + 1),
      academicHistory?.startMonth,
    );
    academicStartYear = _validIntValue(startYears, academicHistory?.startYear);
    academicEndMonth = academicHistory?.endMonth;
    academicEndYear = academicHistory?.endYear;
    submitted = false;
    _normalizeAcademicEndSelection();
    update();
  }

  void markSubmitted() {
    submitted = true;
    update();
  }

  void selectEducationBoard(String? value) {
    educationBoardId = value;
    academicClassId = null;
    update();
  }

  void selectAcademicClass(String? value) {
    academicClassId = value;
    update();
  }

  void selectAcademicStartMonth(int? value) {
    academicStartMonth = value;
    _normalizeAcademicEndSelection();
    update();
  }

  void selectAcademicStartYear(int? value) {
    academicStartYear = value;
    _normalizeAcademicEndSelection();
    update();
  }

  void selectAcademicEndMonth(int? value) {
    academicEndMonth = value;
    update();
  }

  void selectAcademicEndYear(int? value) {
    academicEndYear = value;

    if (!endMonths.contains(academicEndMonth)) {
      academicEndMonth = null;
    }

    update();
  }

  Future<bool> save() async {
    if (hasAcademicHistory || isSaving) {
      return false;
    }

    if (educationBoardId == null ||
        academicClassId == null ||
        academicStartMonth == null ||
        academicStartYear == null ||
        academicEndMonth == null ||
        academicEndYear == null) {
      return false;
    }

    final authController = Get.find<AuthController>();
    final schoolAcademicClassId = _selectedSchoolAcademicClassId(
      authController,
    );

    if (schoolAcademicClassId == null) {
      AppSnackBar.showError(
        title: 'Unable to save academic setup',
        message: 'The selected academic class is unavailable.',
        fallbackMessage: 'Please select the academic class again.',
      );
      return false;
    }

    isSaving = true;
    update();

    try {
      final response = await api.post<AcademicHistoryModel>(
        ApiRoutes.academicHistories,
        headers: {'Authorization': 'Bearer ${authController.authToken}'},
        body: {
          'school_academic_class': schoolAcademicClassId,
          'start_month': academicStartMonth,
          'start_year': academicStartYear,
          'end_month': academicEndMonth,
          'end_year': academicEndYear,
        },
        fromJson: (value) => AcademicHistoryModel.fromJson(
          Map<String, dynamic>.from(value as Map),
        ),
      );

      if (!response.isSuccess) {
        AppSnackBar.showError(
          title: 'Unable to save academic setup',
          message: response.message,
        );
        return false;
      }

      if (response.data.isNotEmpty) {
        academicHistory = response.data.first;
        await authController.updateAcademicHistory(academicHistory!);
      }

      _hasSavedSettings = response.data.isEmpty;
      return true;
    } finally {
      isSaving = false;
      update();
    }
  }

  void _normalizeAcademicEndSelection() {
    if (!canSelectAcademicEnd) {
      academicEndMonth = null;
      academicEndYear = null;
      return;
    }

    if (!endYears.contains(academicEndYear)) {
      academicEndYear = null;
    }

    if (!endMonths.contains(academicEndMonth)) {
      academicEndMonth = null;
    }
  }

  List<EducationBoardModel> _educationBoardsFromAuth(
    AuthController authController,
  ) {
    final boardsById = <String, EducationBoardModel>{};

    for (final school in authController.schoolAcademicClasses) {
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

  String? _selectedSchoolAcademicClassId(AuthController authController) {
    for (final school in authController.schoolAcademicClasses) {
      for (final board in school.educationBoards) {
        if (board.id != educationBoardId) {
          continue;
        }

        for (final academicClass in board.academicClasses) {
          if (academicClass.id != academicClassId) {
            continue;
          }

          if (academicClass.schoolAcademicClassId.isNotEmpty) {
            return academicClass.schoolAcademicClassId;
          }

          if (school.schoolAcademicClassId.isNotEmpty) {
            return school.schoolAcademicClassId;
          }
        }
      }
    }

    return null;
  }

  String? _validStringValue(Iterable<String> values, String value) {
    return value.isNotEmpty && values.contains(value) ? value : null;
  }

  int? _validIntValue(Iterable<int> values, int? value) {
    return value != null && values.contains(value) ? value : null;
  }
}
