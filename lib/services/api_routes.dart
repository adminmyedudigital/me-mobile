abstract final class ApiRoutes {
  static const String publicBaseUrl = String.fromEnvironment(
    'PUBLIC_API_BASE_URL',
    defaultValue: 'https://api-sit-myedudigital.onrender.com',
  );

  static const String studentBaseUrl = String.fromEnvironment(
    'STUDENT_API_BASE_URL',
    defaultValue: 'https://api-sit-myedudigital.onrender.com/student',
  );

  static const String webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'https://me-sit-myedudigital.onrender.com',
  );

  static String get states => public('/states');
  static String get studentSignIn => student('/signin');
  static String get signUpWeb => web('/sign-up');
  static String get forgottenPasswordWeb => web('/forgotten-password');

  static String public(String path) => _join(publicBaseUrl, path);

  static String student(String path) => _join(studentBaseUrl, path);

  static String web(String path) => _join(webBaseUrl, path);

  static String _join(String baseUrl, String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';

    return '$cleanBaseUrl$cleanPath';
  }
}
