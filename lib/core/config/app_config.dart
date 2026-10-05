enum AppEnvironment {
  dev,
  qa,
  prod,
}

class AppConfig {
  final AppEnvironment environment;
  final String appTitle;
  final String apiBaseUrl;
  final bool enableVerboseLogging;
  final bool isDebugMode;

  const AppConfig({
    required this.environment,
    required this.appTitle,
    required this.apiBaseUrl,
    required this.enableVerboseLogging,
    required this.isDebugMode,
  });

  bool get isProduction => environment == AppEnvironment.prod;

  static late final AppConfig instance;

  static void initialize(AppConfig config) {
    instance = config;
  }
}
