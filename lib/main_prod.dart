import 'core/config/app_config.dart';
import 'main.dart';
import 'package:flutter/foundation.dart';

void main() async {
  const prodConfig = AppConfig(
    environment: AppEnvironment.prod,
    appTitle: 'QR Code Generator',
    apiBaseUrl: 'https://api.qrgenerator.com',
    enableVerboseLogging: false,
    isDebugMode: kDebugMode,
  );
  await runQrApp(prodConfig);
}
