import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../cached_service/shared_pref_service.dart';

class ThemingService {
  ThemingService._(); 
  static final ThemingService instance = ThemingService._();
  bool get isDarkMode => Get.isDarkMode;
  late Rx<ThemeMode> currentThemeMode;

  void init() {
    _getCurrentThemeFromSharedPref();
  }

  void changeThemeMode({required ThemeMode themeMode}) async {
    currentThemeMode.value = themeMode;
    Get.changeThemeMode(themeMode);
    await _setCurrentThemeInSharedPref();
  }

  Future<void> _setCurrentThemeInSharedPref() async {
    await SharedPrefService.instance.setValue(
      value: currentThemeMode.value.name,
      key: ThemeModeEnum.currentThemeMode,
    );
  }

  void _getCurrentThemeFromSharedPref() {
    currentThemeMode = Rx<ThemeMode>(ThemeMode.system);
    String? data = SharedPrefService.instance.getValue<String>(
      ThemeModeEnum.currentThemeMode,
    );
    if (data != null) {
      currentThemeMode.value = ThemeMode.values.byName(data);
      return;
    }
  }

  Rx<String> get getThemeModeName => switch (currentThemeMode.value) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',

    ThemeMode.dark => 'Dark',
  }.obs;
}

enum ThemeModeEnum { currentThemeMode }
