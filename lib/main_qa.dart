import 'core/config/app_config.dart';
import 'main.dart';

void main() async {
  const qaConfig = AppConfig(
    environment: AppEnvironment.qa,
    appTitle: 'QR Generator [QA]',
    apiBaseUrl: 'https://qa-api.qrgenerator.com',
    enableVerboseLogging: true,
    isDebugMode: true,
  );
  await runQrApp(qaConfig);
}
