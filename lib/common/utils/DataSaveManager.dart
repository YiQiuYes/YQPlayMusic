import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class DataSaveManager {
  /// 保存数据
  static Future<void> setLocalStorage(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = value.runtimeType.toString();

    switch (type) {
      case "String":
        prefs.setString(key, value as String);
        break;
      case "int":
        prefs.setInt(key, value as int);
        break;
      case "bool":
        prefs.setBool(key, value as bool);
        break;
      case "double":
        prefs.setDouble(key, value as double);
        break;
      case "List<String>":
        prefs.setStringList(key, value as List<String>);
        break;
      case "_InternalLinkedHashMap<String, String>":
        prefs.setString(key, json.encode(value));
        break;
    }
  }

  /// 判断是否是json字符串
  static _isJson(String value) {
    try {
      const JsonDecoder().convert(value);
      return true;
    } catch(e) {
      return false;
    }
  }

  /// 取数据
  static Future<T> getLocalStorage<T>(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic value = prefs.get(key);
    return value;
  }

  /// 删除指定数据
  static void remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key); //删除指定键
  }

  /// 清空整个缓存
  static void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); ////清空缓存
  }
}
