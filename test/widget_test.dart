import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_generator/core/config/app_config.dart';
import 'package:qr_generator/core/di/app_di.dart';
import 'package:qr_generator/main.dart';

void main() {
  testWidgets('QR Generator App smoke test', (WidgetTester tester) async {
    const config = AppConfig(
      environment: AppEnvironment.dev,
      appTitle: 'QR Code Generator Test',
      apiBaseUrl: 'https://test.api',
      enableVerboseLogging: false,
    );

    AppConfig.initialize(config);
    await AppDI.init(config);

    await tester.pumpWidget(const QrApp());
    await tester.pumpAndSettle();

    // Verify title and input field are rendered
    expect(find.text('QR Code Generator'), findsOneWidget);
    expect(find.text('QR Content'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Generate QR Code'), findsOneWidget);
  });
}
