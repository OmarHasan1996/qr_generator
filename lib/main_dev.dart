import 'core/config/app_config.dart';
import 'main.dart';

void main() async {
  const devConfig = AppConfig(
    environment: AppEnvironment.dev,
    appTitle: 'QR Generator [DEV]',
    apiBaseUrl: 'https://dev-api.qrgenerator.com',
    enableVerboseLogging: true,
    isDebugMode: true,
  );
  await runQrApp(devConfig);
}
