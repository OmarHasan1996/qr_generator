import 'package:flutter/foundation.dart';

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
  final bool isDebugMode = kDebugMode;

  const AppConfig({
    required this.environment,
    required this.appTitle,
    required this.apiBaseUrl,
    required this.enableVerboseLogging,
  });

  bool get isProduction => environment == AppEnvironment.prod;

  static late final AppConfig instance;

  static void initialize(AppConfig config) {
    instance = config;
  }
}
