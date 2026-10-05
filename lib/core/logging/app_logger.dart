import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

enum LogLevel { debug, info, warn, error }

abstract class AppLogger {
  void debug(String message, {String? tag, Map<String, dynamic>? metadata});
  void info(String message, {String? tag, Map<String, dynamic>? metadata});
  void warn(String message, {String? tag, Object? error, StackTrace? stackTrace, Map<String, dynamic>? metadata});
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace, Map<String, dynamic>? metadata});
}

class AppLoggerImpl implements AppLogger {
  final AppConfig config;

  AppLoggerImpl({required this.config});

  // LOG-003: Redact sensitive fields/keywords
  static const List<String> _sensitiveKeys = [
    'password',
    'token',
    'secret',
    'auth',
    'bearer',
    'api_key',
    'credit_card',
    'ssn',
  ];

  @override
  void debug(String message, {String? tag, Map<String, dynamic>? metadata}) {
    // LOG-004: DEBUG logs stripped in Production builds
    if (config.isProduction || !config.enableVerboseLogging) return;
    _log(LogLevel.debug, message, tag: tag, metadata: metadata);
  }

  @override
  void info(String message, {String? tag, Map<String, dynamic>? metadata}) {
    _log(LogLevel.info, message, tag: tag, metadata: metadata);
  }

  @override
  void warn(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      LogLevel.warn,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    final sanitizedMessage = _redactSensitiveData(message);
    final sanitizedMap = metadata != null ? _redactMap(metadata) : null;
    final logTag = tag ?? 'QRGenerator';

    final structuredLog = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'level': level.name.toUpperCase(),
      'tag': logTag,
      'environment': config.environment.name,
      'message': sanitizedMessage,
    };

    if (sanitizedMap != null) {
      structuredLog['metadata'] = sanitizedMap;
    }
    if (error != null) {
      structuredLog['error'] = error.toString();
    }

    if (kDebugMode) {
      debugPrint('[${structuredLog['level']}][${structuredLog['tag']}] $sanitizedMessage');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }

    // In production, WARN and ERROR can be sent to remote crash reporting sink (e.g. Sentry/Crashlytics)
    if (config.isProduction && (level == LogLevel.warn || level == LogLevel.error)) {
      _sendToRemoteSink(level, sanitizedMessage, error, stackTrace, sanitizedMap);
    }
  }

  String _redactSensitiveData(String input) {
    String redacted = input;
    for (final key in _sensitiveKeys) {
      final regex = RegExp('$key[:=]\\s*([^\\s,]+)', caseSensitive: false);
      redacted = redacted.replaceAllMapped(regex, (match) => '$key=[REDACTED]');
    }
    return redacted;
  }

  Map<String, dynamic> _redactMap(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      if (_sensitiveKeys.any((s) => key.toLowerCase().contains(s))) {
        result[key] = '[REDACTED]';
      } else if (value is Map<String, dynamic>) {
        result[key] = _redactMap(value);
      } else if (value is String) {
        result[key] = _redactSensitiveData(value);
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  void _sendToRemoteSink(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  ) {
    // Hooks for remote telemetry in production targets
  }
}
