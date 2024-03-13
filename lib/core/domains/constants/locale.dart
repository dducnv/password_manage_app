import 'dart:ui';

List<AppLocateModel> appListLocale = [
  AppLocateModel(id: 2, countryName: "English", locale: const Locale("en")),
  AppLocateModel(id: 1, countryName: "Tiếng Việt", locale: const Locale("vi"))
];

class AppLocateModel {
  final int id;
  final String countryName;
  final Locale locale;

  AppLocateModel(
      {required this.id, required this.countryName, required this.locale});
}
