# QR Generator - Cross-Platform Application

A modern, production-grade cross-platform application built with **Flutter (Dart)** to generate QR codes with optional embedded logo images and direct image download/export capabilities across **Web, Android, iOS, macOS, Windows, and Linux**.

Built in accordance with the **ENOC Engineering Guardrails**.

---

## Key Features

- 📱 **Cross-Platform Support**: Full feature parity across Mobile (Android, iOS), Web, and Desktop (macOS, Windows, Linux).
- 🖼️ **Optional Logo Overlay**: Pick or change any custom logo image from device gallery/storage to embed at the center of the generated QR code.
- 📁 **Select Save Directory**: Custom output directory selection prior to saving on Native platforms, with seamless Blob download handling on Web.
- ⬇️ **Download & Save**: Export generated QR codes instantly as high-resolution PNG images.
- 🎨 **Modern Material 3 UI**: Clean, responsive layout supporting light and dark themes out of the box.

---

## Architectural Principles (ENOC Guardrails)

### 1. MVVM with Clean Architecture (ARCH-001, ARCH-003)
The application strictly enforces separation of concerns into distinct layers:
- **Presentation Layer**: Passive Views (`QrGeneratorScreen`, `QrInputForm`, `QrPreviewCard`, `LogoPickerWidget`) rendering state and forwarding events without owning business rules.
- **Domain Layer**: Pure business logic isolated in Use Cases (`GenerateQrCodeUseCase`, `PickLogoImageUseCase`, `SaveQrCodeUseCase`) and Repository Interfaces (`QrRepository`, `ImagePickerRepository`, `FileStorageRepository`).
- **Data Layer**: Concrete repository implementations (`QrRepositoryImpl`, `ImagePickerRepositoryImpl`, `FileStorageRepositoryImpl`) and platform datasources (`QrService`, `ImagePickerService`, `FileStorageService`).

### 2. Unidirectional Data Flow (ARCH-002)
- State is modeled as a single, immutable source of truth (`QrGeneratorState`).
- State transitions occur exclusively via explicit user intents/events (`QrGeneratorEvent`).
- The ViewModel (`QrGeneratorViewModel`) consumes events and emits immutable state objects.

### 3. Dependency Injection (ARCH-004)
- Centralized Service Locator (`AppDI` wrapping `GetIt`) injects abstract dependencies into ViewModels, Use Cases, and Repositories.

### 4. Injected Structured Logging (LOG-001 - LOG-004)
- Injected `AppLogger` abstraction with level tags (`DEBUG`, `INFO`, `WARN`, `ERROR`) and structured metadata.
- PII and sensitive key redaction (`LOG-003`).
- Debug logs compiled out in Production targets (`LOG-004`).

### 5. Multi-Environment Configuration (ENV-001 - ENV-003)
Separate entry points for distinct environments:
- **Development**: `lib/main_dev.dart`
- **QA**: `lib/main_qa.dart`
- **Production**: `lib/main_prod.dart`

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13+)

### Running the Application

#### Development Environment
```bash
flutter run -t lib/main_dev.dart
```

#### QA Environment
```bash
flutter run -t lib/main_qa.dart
```

#### Production Environment
```bash
flutter run -t lib/main_prod.dart
```

#### Web Application
```bash
flutter run -d chrome -t lib/main_prod.dart
```

---

## Testing & Quality Gates

### Run Static Analysis
```bash
flutter analyze
```

### Run Unit Tests
```bash
flutter test --coverage
```

Unit tests follow the **Given-When-Then** pattern with mocked boundaries (`mocktail`), covering happy paths, edge cases, and failure scenarios.

---

## CI/CD Pipeline (CICD-001)

An automated GitHub Actions workflow (`.github/workflows/ci.yml`) validates code formatting, static analysis, unit test coverage, and builds for Web and Android on every pull request.
