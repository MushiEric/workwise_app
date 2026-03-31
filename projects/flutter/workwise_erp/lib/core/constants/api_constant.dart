import '../config/environment.dart';

class ApiConstant {
  ApiConstant._();

  /// The effective base URL used for legacy utilities (image URL resolution, auth fallback paths, etc.).
  ///
  /// This is updated when a workspace is selected; otherwise it defaults
  /// to the current environment (`EnvConfig.current.baseUrl`).
  static String baseUrl = EnvConfig.current.baseUrl;

  /// Override the base URL at runtime (workspace switch).
  static void setBaseUrl(String url) {
    baseUrl = url;
  }
}
