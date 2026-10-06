import 'package:flutter/material.dart';
import 'core/config/app_config.dart';
import 'core/di/app_di.dart';
import 'presentation/views/qr_generator_screen.dart';

Future<void> runQrApp(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize(config);
  await AppDI.init(config);
  runApp(const QrApp());
}

void main() async {
  // Default entry point runs in Prod configuration
  const defaultConfig = AppConfig(
    environment: AppEnvironment.prod,
    appTitle: 'QR Code Generator',
    apiBaseUrl: 'https://api.qrgenerator.com',
    enableVerboseLogging: false,
  );
  await runQrApp(defaultConfig);
}

class QrApp extends StatelessWidget {
  const QrApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();

    return MaterialApp(
      title: config.appTitle,
      debugShowCheckedModeBanner: config.isDebugMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: QrGeneratorScreen(
        viewModel: sl(),
      ),
    );
  }
}
