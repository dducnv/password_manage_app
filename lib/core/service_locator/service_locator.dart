import 'package:password_manage_app/main.dart';
import 'package:password_manage_app/ui/screens/create_account/create_account.dart';
import 'package:password_manage_app/ui/screens/details_account/details_account.dart';
import 'package:password_manage_app/ui/screens/main_view/main_view_model.dart';
import 'package:password_manage_app/ui/screens/home/home.dart';
import 'package:password_manage_app/ui/screens/password_generator/password_generator.dart';
import 'package:password_manage_app/ui/screens/setting/setting.dart';

import '../../ui/screens/create_category/create_category.dart';

enum DependencyInstance { nwUsecaseProvider }

class ServiceLocator {
  static final instance = ServiceLocator._internal();
  ServiceLocator._internal();
  void registerDependencies() {
    _registerUseCase();
    _registerViewModel();
  }

  void _registerUseCase() {}

  void _registerViewModel() {
    locator.registerFactory<MainViewModel>(() => MainViewModel());
    locator.registerFactory<HomeViewModel>(() => HomeViewModel());
    locator.registerFactory<SettingViewModel>(() => SettingViewModel());
    locator.registerFactory<PasswordGeneratorViewModel>(
        () => PasswordGeneratorViewModel());
    locator.registerFactory<DetailsAccountViewModel>(
        () => DetailsAccountViewModel());
    locator.registerFactory<CreateAccountViewModel>(
        () => CreateAccountViewModel());
    locator.registerFactory<CreateCategoryViewModel>(
        () => CreateCategoryViewModel());
  }
}
