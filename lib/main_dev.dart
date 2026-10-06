import 'core/config/app_config.dart';
import 'main.dart';
import 'package:flutter/foundation.dart';

void main() async {
  const devConfig = AppConfig(
    environment: AppEnvironment.dev,
    appTitle: 'QR Generator [DEV]',
    apiBaseUrl: 'https://dev-api.qrgenerator.com',
    enableVerboseLogging: true,
    isDebugMode: kDebugMode,
  );
  await runQrApp(devConfig);
}
