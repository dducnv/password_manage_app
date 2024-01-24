import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/main.dart';

import 'package:password_manage_app/ui/screens/screen.dart';

enum DependencyInstance {
  nwUsecaseProvider,
  sqlUsecaseProvider,
  sqlCategoryUsecase,
  sqlAccountUsecase,
}

class ServiceLocator {
  static final instance = ServiceLocator._internal();
  ServiceLocator._internal();
  void registerDependencies() {
    _registerUseCase();
    _registerViewModel();
  }

  void _registerUseCase() {
    locator.registerLazySingleton<UsecaseProvider>(() => SqlUsecaseProvider(),
        instanceName: DependencyInstance.sqlUsecaseProvider.name);

    locator.registerFactory<AccountUseCase>(
        () => locator
            .get<UsecaseProvider>(
                instanceName: DependencyInstance.sqlUsecaseProvider.name)
            .getAccountUseCase(),
        instanceName: DependencyInstance.sqlAccountUsecase.name);

    locator.registerFactory<CategoryUseCase>(
        () => locator
            .get<UsecaseProvider>(
                instanceName: DependencyInstance.sqlUsecaseProvider.name)
            .getCategoryUseCase(),
        instanceName: DependencyInstance.sqlCategoryUsecase.name);
  }

  void _registerViewModel() {
    locator.registerFactory<HomeViewModel>(
      () => HomeViewModel(
        sqlCategoryUsecase: locator.get<CategoryUseCase>(
            instanceName: DependencyInstance.sqlCategoryUsecase.name),
      ),
    );
    locator.registerFactory<SettingViewModel>(() => SettingViewModel());
    locator.registerFactory<PasswordGeneratorViewModel>(
        () => PasswordGeneratorViewModel());
    locator.registerFactory<DetailsAccountViewModel>(
      () => DetailsAccountViewModel(
        sqlAccountUsecase: locator.get<AccountUseCase>(
            instanceName: DependencyInstance.sqlAccountUsecase.name),
      ),
    );
    locator.registerFactory<CreateAccountViewModel>(() =>
        CreateAccountViewModel(
            sqlAccountUsecase: locator.get<AccountUseCase>(
                instanceName: DependencyInstance.sqlAccountUsecase.name),
            sqlCategoryUsecase: locator.get<CategoryUseCase>(
                instanceName: DependencyInstance.sqlCategoryUsecase.name)));
    locator.registerFactory<CreateCategoryViewModel>(
        () => CreateCategoryViewModel());
    locator
        .registerFactory<UpdateAccountViewModel>(() => UpdateAccountViewModel(
              sqlCategoryUsecase: locator.get<CategoryUseCase>(
                  instanceName: DependencyInstance.sqlCategoryUsecase.name),
              sqlAccountUsecase: locator.get<AccountUseCase>(
                  instanceName: DependencyInstance.sqlAccountUsecase.name),
            ));
    locator.registerFactory<LocalAuthViewModel>(() => LocalAuthViewModel());
    locator.registerFactory<SplashScreenViewModel>(() => SplashScreenViewModel(
        sqlCategoryUsecase: locator.get<CategoryUseCase>(
            instanceName: DependencyInstance.sqlCategoryUsecase.name)));
  }
}
