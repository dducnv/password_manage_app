import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:privacy_screen/privacy_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/service_locator/service_locator.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:provider/provider.dart';

GetIt locator = GetIt.instance;

String currentThemeMode = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ServiceLocator.instance.registerDependencies();
  await SqliteStack.instance.inititalDB([
    AccountModel().createTableCommand,
    CategoryModel().createTableCommand,
  ]);
  AppLanguageProvider appLanguage = AppLanguageProvider();
  await appLanguage.fetchLocale();
  await LocalAuthConfig.instance.init();
  var getThemeStorage = await SecureStorage.instance
          .read(SecureStorageKeys.themMode.toString()) ??
      "";
  if (getThemeStorage == "") {
    await SecureStorage.instance
        .save(SecureStorageKeys.themMode.toString(), ThemeMode.system.name);
    currentThemeMode = ThemeMode.system.name;
  } else {
    currentThemeMode = getThemeStorage;
  }

  await PrivacyScreen.instance.enable(
    iosOptions: const PrivacyIosOptions(
      enablePrivacy: true,
      privacyImageName: "LaunchImage",
      autoLockAfterSeconds: 5,
      lockTrigger: IosLockTrigger.didEnterBackground,
    ),
    androidOptions: const PrivacyAndroidOptions(
      enableSecure: true,
      autoLockAfterSeconds: 60 * 3,
    ),
    backgroundColor: Colors.white.withOpacity(0),
    blurEffect: PrivacyBlurEffect.extraLight,
  );

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('vi')],
    path: 'assets/locales',
    fallbackLocale: const Locale('en'),
    useOnlyLangCode: true,
    useFallbackTranslations: true,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AppLanguageProvider(),
        ),
        ChangeNotifierProvider(create: (context) => DataShared.instance)
      ],
      child: Consumer<AppLanguageProvider>(builder: (ctx, langProvider, _) {
        return Consumer<ThemeProvider>(
          builder: (ctx, themeObject, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            themeMode: themeObject.mode,
            navigatorKey: GlobalKeys.appRootNavigatorKey,
            theme: ThemeData(
              colorScheme: const ColorScheme(
                background: Color(0xFFE9E9E9),
                brightness: Brightness.light,
                error: Color(0xFFE57373),
                onBackground: Color(0xFF000000),
                onError: Color(0xFF000000),
                onPrimary: Color(0xFFFFFFFF),
                onSecondary: Color(0xFF000000),
                onSurface: Color(0xFF000000),
                primary: Color(0xFF2D5BD3),
                secondary: Color(0xFFE9E9E9),
                surface: Color(0xFFE9E9E9),
                surfaceVariant: Color.fromARGB(255, 219, 219, 219),
                secondaryContainer: Color(0xFFFFFFFF),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: const ColorScheme(
                background: Color(0xFF121212),
                brightness: Brightness.dark,
                error: Color(0xFFCF6679),
                onBackground: Color(0xFFFFFFFF),
                onError: Color(0xFFFFFFFF),
                onPrimary: Color(0xFFFFFFFF),
                onSecondary: Color(0xFFFFFFFF),
                onSurface: Color(0xFFFFFFFF),
                primary: Color(0xFF2D5BD3),
                secondary: Color(0xFF121212),
                surface: Color(0xFF121212),
                secondaryContainer: Color(0xFF212121),
                surfaceVariant: Color.fromARGB(255, 42, 42, 42),
              ),
            ),
            title: 'Password Manager',
            initialRoute: RoutePaths.splashRote,
            onGenerateRoute: AppGenerateRoute.generateRoute,
            builder: (context, child) {
              return PrivacyGate(
                lockBuilder: (ctx) => const LocalAuthView(),
                // Give it a key
                navigatorKey: GlobalKeys.appRootNavigatorKey,
                // onLifeCycleChanged: (value) => print(value),
                // onLock: () => print("onLock"),
                // onUnlock: () => print("onUnlock"),
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1)),
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.background,
                    child: SafeArea(
                      bottom: false,
                      right: false,
                      left: false,
                      child: AnnotatedRegion(
                          value: SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                            statusBarBrightness:
                                themeObject.mode == ThemeMode.light
                                    ? Brightness.light
                                    : Brightness.dark,
                            statusBarIconBrightness:
                                themeObject.mode == ThemeMode.light
                                    ? Brightness.dark
                                    : Brightness.light,
                          ),
                          child: child!),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
