import 'dart:developer'; 

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  SharedPrefService._();

  
  static final SharedPrefService instance = SharedPrefService._();

  static late SharedPreferences _sharedPreferences;

  static bool _isInitialized = false;

  
  
  
  static Future<void> init() async {
    
    if (_isInitialized) {
      return;
    }

    _sharedPreferences = await SharedPreferences.getInstance();
    _isInitialized = true; 
  }


  T? getValue<T>(Enum key) {
    
    if (!_isInitialized) {
      log('Error: SharedPrefService not initialized. Call init() first.');
      return null;
    }
    if (T == int) {
      return _sharedPreferences.getInt(key.name) as T?;
    } else if (T == double) {
      return _sharedPreferences.getDouble(key.name) as T?;
    } else if (T == String) {
      return _sharedPreferences.getString(key.name) as T?;
    } else if (T == bool) {
      return _sharedPreferences.getBool(key.name) as T?;
    } else {
      log('Unsupported type for getValue: $T');
      return null;
    }
  }

  
  
  
  
  
  
  Future<bool> setValue<T>({required T value, required Enum key}) async {
    
    if (!_isInitialized) {
      log('Error: SharedPrefService not initialized. Call init() first.');
      return false;
    }

    try {
      
      if (value is int) {
        return await _sharedPreferences.setInt(key.name, value);
      } else if (value is String) {
        return await _sharedPreferences.setString(key.name, value);
      } else if (value is bool) {
        return await _sharedPreferences.setBool(key.name, value);
      } else if (value is double) {
        return await _sharedPreferences.setDouble(key.name, value);
      } else {
        log('Unsupported type for setValue: ${value.runtimeType}');
        return false;
      }
    } catch (e) {
      log('Error setting value for key ${key.name}: $e');
      return false;
    }
  }
  
  Future<bool> removeValue({required Enum key}) async {
    
    if (!_isInitialized) {
      log('Error: SharedPrefService not initialized. Call init() first.');
      return false;
    }

    try {
      return await _sharedPreferences.remove(key.name);
    } catch (e) {
      log('Error removing value for key ${key.name}: $e');
      return false;
    }
  }


  Future<bool> clearAll() async {
    if (!_isInitialized) {
      log('Error: SharedPrefService not initialized. Call init() first.');
      return false;
    }
    try {
      return await _sharedPreferences.clear();
    } catch (e) {
      log('Error clearing all shared preferences: $e');
      return false;
    }
  }
}
