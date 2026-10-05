import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../logging/app_logger.dart';
import '../../data/datasources/qr_service.dart';
import '../../data/datasources/file_storage_service.dart';
import '../../data/datasources/image_picker_service.dart';
import '../../data/repositories/qr_repository_impl.dart';
import '../../data/repositories/image_picker_repository_impl.dart';
import '../../data/repositories/file_storage_repository_impl.dart';
import '../../domain/repositories/qr_repository.dart';
import '../../domain/repositories/image_picker_repository.dart';
import '../../domain/repositories/file_storage_repository.dart';
import '../../domain/usecases/generate_qr_code_use_case.dart';
import '../../domain/usecases/pick_logo_image_use_case.dart';
import '../../domain/usecases/save_qr_code_use_case.dart';
import '../../presentation/viewmodels/qr_generator_view_model.dart';

final GetIt sl = GetIt.instance;

class AppDI {
  static Future<void> init(AppConfig config) async {
    // Reset if already registered (useful for re-initialization in tests)
    await sl.reset();

    // 1. Config & Core Services
    sl.registerSingleton<AppConfig>(config);
    sl.registerLazySingleton<AppLogger>(() => AppLoggerImpl(config: sl()));

    // 2. Datasources / Platform Services
    sl.registerLazySingleton<QrService>(() => QrServiceImpl());
    sl.registerLazySingleton<FileStorageService>(() => FileStorageService());
    sl.registerLazySingleton<ImagePickerService>(() => ImagePickerServiceImpl());

    // 3. Repositories
    sl.registerLazySingleton<QrRepository>(
      () => QrRepositoryImpl(qrService: sl(), logger: sl()),
    );
    sl.registerLazySingleton<ImagePickerRepository>(
      () => ImagePickerRepositoryImpl(imagePickerService: sl(), logger: sl()),
    );
    sl.registerLazySingleton<FileStorageRepository>(
      () => FileStorageRepositoryImpl(fileStorageService: sl(), logger: sl()),
    );

    // 4. Use Cases
    sl.registerLazySingleton<GenerateQrCodeUseCase>(
      () => GenerateQrCodeUseCase(qrRepository: sl(), logger: sl()),
    );
    sl.registerLazySingleton<PickLogoImageUseCase>(
      () => PickLogoImageUseCase(imagePickerRepository: sl(), logger: sl()),
    );
    sl.registerLazySingleton<SaveQrCodeUseCase>(
      () => SaveQrCodeUseCase(fileStorageRepository: sl(), logger: sl()),
    );

    // 5. ViewModel / Factory
    sl.registerFactory<QrGeneratorViewModel>(
      () => QrGeneratorViewModel(
        generateQrCodeUseCase: sl(),
        pickLogoImageUseCase: sl(),
        saveQrCodeUseCase: sl(),
        logger: sl(),
      ),
    );
  }
}
