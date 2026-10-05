import 'core/config/app_config.dart';
import 'main.dart';

void main() async {
  const prodConfig = AppConfig(
    environment: AppEnvironment.prod,
    appTitle: 'QR Code Generator',
    apiBaseUrl: 'https://api.qrgenerator.com',
    enableVerboseLogging: false,
    isDebugMode: false,
  );
  await runQrApp(prodConfig);
}
