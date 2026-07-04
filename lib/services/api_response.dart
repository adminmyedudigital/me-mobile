class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  final List<T> data;
  final String message;
  final int status;

  bool get isSuccess => status >= 200 && status < 300;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic value)? fromJson,
    int? fallbackStatus,
  }) {
    final rawData = json['data'];
    final values = rawData is List
        ? rawData
        : rawData == null
        ? const <dynamic>[]
        : <dynamic>[rawData];

    return ApiResponse<T>(
      data: values
          .map((value) => fromJson == null ? value as T : fromJson(value))
          .toList(),
      message: (json['message'] ?? '').toString(),
      status: _statusFrom(json['status']) ?? fallbackStatus ?? 0,
    );
  }

  factory ApiResponse.failure({required String message, required int status}) {
    return ApiResponse<T>(
      data: List<T>.empty(),
      message: message,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data, 'message': message, 'status': status};
  }

  static int? _statusFrom(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
