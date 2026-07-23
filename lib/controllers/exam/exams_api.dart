part of 'exams_controller.dart';

/*
  Contains only exam-related network workflows.
  As a part of the controller library, these methods can safely update the
  controller's private request guards and reactive state.
*/
extension ExamsApi on ExamsController {
  /// Loads subject/topic options before opening the result form.
  Future<void> loadSubjectTopics() async {
    if (isApiOperationInProgress) return;

    final academicHistory = _authController.academicHistory;
    final educationBoardId = academicHistory?.educationBoardId.trim() ?? '';
    final academicClassId = academicHistory?.academicClassId.trim() ?? '';

    if (educationBoardId.isEmpty || academicClassId.isEmpty) {
      subjects = const [];
      subjectsErrorMessage = 'Complete your academic setup to load subjects.';
      return;
    }

    isLoadingSubjects.value = true;
    subjectsErrorMessage = null;
    try {
      final endpoint = ApiRoutes.subjectTopics(
        educationBoardId,
        academicClassId,
      );

      final response = await api.get<ExamSubjectModel>(
        endpoint,
        headers: _authorizationHeaders,
        fromJson: (value) =>
            ExamSubjectModel.fromJson(Map<String, dynamic>.from(value as Map)),
      );

      if (!response.isSuccess) {
        subjects = const [];
        subjectsErrorMessage = response.message.trim().isEmpty
            ? 'Unable to load subjects and topics.'
            : response.message;
        return;
      }

      subjects = response.data
          .where((subject) => subject.id.isNotEmpty && subject.label.isNotEmpty)
          .toList(growable: false);
      subjectsErrorMessage = subjects.isEmpty
          ? 'No subjects or topics are available for your class.'
          : null;
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  /// Performs the first/full exam-list load with a centered loader.
  Future<bool> loadExams() async {
    if (isApiOperationInProgress) return false;

    isLoadingExams.value = true;
    try {
      return await _fetchExams();
    } finally {
      isLoadingExams.value = false;
    }
  }

  /// Refreshes the existing list while RefreshIndicator owns the only loader.
  Future<bool> refreshExams() async {
    if (isApiOperationInProgress) return false;

    isRefreshingExams.value = true;
    try {
      return await _fetchExams();
    } finally {
      isRefreshingExams.value = false;
    }
  }

  /// Validates, posts, and refreshes the list as one submission workflow.
  ///
  /// Returns true only when the POST and the follow-up GET are successful.
  /// The screen uses this result to decide whether it is safe to navigate
  /// back to the refreshed exam list.
  Future<bool> submitExamResult() async {
    if (!validateResultForm()) return false;
    if (isApiOperationInProgress) return false;

    final payload = _buildExamPayload();
    if (payload == null) return false;

    final requestSessionGeneration = _sessionGeneration;
    isSubmittingExam.value = true;
    try {
      // Skip POST when a previous POST succeeded but its refresh failed.
      if (!_hasSubmittedExamPendingRefresh) {
        final requestBody = payload.toJson();

        final response = await api.post<dynamic>(
          ApiRoutes.exams,
          headers: _authorizationHeaders,
          body: requestBody,
        );

        if (requestSessionGeneration != _sessionGeneration) {
          return false;
        }
        if (!response.isSuccess) {
          AppSnackBar.showError(
            title: 'Unable to save exam result',
            message: response.message,
          );
          return false;
        }
        _hasSubmittedExamPendingRefresh = true;
      }

      // Always refresh directly after a successful POST so the list reflects
      // the backend response rather than optimistic local data.
      final didRefresh = await _fetchExams(
        expectedSessionGeneration: requestSessionGeneration,
      );
      if (didRefresh) {
        _hasSubmittedExamPendingRefresh = false;
      }
      return didRefresh;
    } finally {
      isSubmittingExam.value = false;
    }
  }

  /// Updates an exam result and retrieves the authoritative exam list.
  Future<bool> updateExamResult() async {
    if (!validateResultForm()) return false;
    if (isApiOperationInProgress) return false;

    final examId = editingExam?.id.trim() ?? '';
    final payload = _buildExamPayload();
    if (examId.isEmpty || payload == null) {
      AppSnackBar.showError(
        title: 'Unable to update exam result',
        message: 'The exam result details are unavailable.',
      );
      return false;
    }

    final requestSessionGeneration = _sessionGeneration;
    isSubmittingExam.value = true;
    try {
      // When PUT succeeds but GET fails, retry only the list retrieval.
      if (_updatedExamPendingRefreshId != examId) {
        final endpoint = ApiRoutes.exam(examId);
        final requestBody = payload.toJson();

        final response = await api.put<dynamic>(
          endpoint,
          headers: _authorizationHeaders,
          body: requestBody,
        );

        if (requestSessionGeneration != _sessionGeneration) {
          return false;
        }
        if (!response.isSuccess) {
          AppSnackBar.showError(
            title: 'Unable to update exam result',
            message: response.message,
          );
          return false;
        }
        _updatedExamPendingRefreshId = examId;
      }

      final didRefresh = await _fetchExams(
        expectedSessionGeneration: requestSessionGeneration,
      );
      if (didRefresh) {
        _updatedExamPendingRefreshId = null;
      }
      return didRefresh;
    } finally {
      isSubmittingExam.value = false;
    }
  }

  /// Deletes an exam result and retrieves the authoritative exam list.
  Future<bool> deleteExam(String examId) async {
    final normalizedExamId = examId.trim();
    if (normalizedExamId.isEmpty) {
      AppSnackBar.showError(
        title: 'Unable to delete exam result',
        message: 'The exam result ID is unavailable.',
      );
      return false;
    }
    if (isApiOperationInProgress) return false;

    final requestSessionGeneration = _sessionGeneration;
    isDeletingExam.value = true;
    try {
      // A deleted record cannot safely be deleted twice. If DELETE succeeded
      // but GET failed, retry only the list retrieval.
      if (_deletedExamPendingRefreshId != normalizedExamId) {
        final endpoint = ApiRoutes.exam(normalizedExamId);

        final response = await api.delete<dynamic>(
          endpoint,
          headers: _authorizationHeaders,
        );

        if (requestSessionGeneration != _sessionGeneration) {
          return false;
        }
        if (!response.isSuccess) {
          AppSnackBar.showError(
            title: 'Unable to delete exam result',
            message: response.message,
          );
          return false;
        }
        _deletedExamPendingRefreshId = normalizedExamId;
      }

      final didRefresh = await _fetchExams(
        expectedSessionGeneration: requestSessionGeneration,
      );
      if (didRefresh) {
        _deletedExamPendingRefreshId = null;
      }
      return didRefresh;
    } finally {
      isDeletingExam.value = false;
    }
  }

  /// Fetches and replaces the exam cache without changing loader ownership.
  ///
  /// List loading, refreshing, adding, updating, and deleting set the
  /// appropriate loader before calling this shared method.
  Future<bool> _fetchExams({int? expectedSessionGeneration}) async {
    final requestSessionGeneration =
        expectedSessionGeneration ?? _sessionGeneration;

    final response = await api.get<ExamModel>(
      ApiRoutes.exams,
      headers: _authorizationHeaders,
      fromJson: (value) =>
          ExamModel.fromJson(Map<String, dynamic>.from(value as Map)),
    );

    if (requestSessionGeneration != _sessionGeneration) {
      return false;
    }
    if (!response.isSuccess) {
      final message = response.message.trim().isEmpty
          ? 'Unable to load exam results.'
          : response.message;
      examsErrorMessage.value = message;
      AppSnackBar.showError(
        title: 'Unable to load exam results',
        message: message,
      );
      return false;
    }

    exams.assignAll(response.data.where((exam) => exam.id.isNotEmpty));
    examsErrorMessage.value = null;
    return true;
  }

  AddExamPayloadModel? _buildExamPayload() {
    final subject = selectedSubject;
    final topics = selectedTopics;
    final examType = selectedExamType;
    final examDate = selectedExamDate;
    final parsedTotalMarks = int.tryParse(totalMarks.trim());
    final parsedAchievedMarks = int.tryParse(achievedMarks.trim());

    if (subject == null ||
        topics.isEmpty ||
        examType == null ||
        examDate == null ||
        parsedTotalMarks == null ||
        parsedAchievedMarks == null) {
      return null;
    }

    return AddExamPayloadModel(
      subjectId: subject.id,
      subjectTopicIds: topics.map((topic) => topic.id).toList(growable: false),
      examDate: examDate,
      examType: examType,
      examMarks: parsedTotalMarks,
      achievedMarks: parsedAchievedMarks,
    );
  }

  Map<String, String> get _authorizationHeaders {
    return {'Authorization': 'Bearer ${_authController.authToken}'};
  }
}
