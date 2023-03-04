import 'dart:convert';
import 'package:aming_kit/aming_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CacheType {
  string,
  int,
  double,
  bool,
  json,
  stringList,
}


class OuiCache{
  static SharedPreferences? _prefs;
  static SharedPreferences? get pref => _prefs;

  static bool get isInit => isNotNull(_prefs);

  static Future init() async{
    if(!isNotNull(_prefs)){
      _prefs = await SharedPreferences.getInstance();
      log.system("initialization", tag: "Cache");
    }
  }

  static Future<bool> _set(CacheType type, String key, value) async{
    if(!isNotNull(_prefs)){
      _prefs = await SharedPreferences.getInstance();
    }
    remove(key);
    if(value == null){
      return false;
    }
    switch(type){
      case CacheType.bool:
        return await _prefs!.setBool(key, value);
      case CacheType.json:
        return _prefs!.setString(key, json.encode(value));
      case CacheType.int:
        return _prefs!.setInt(key, value);
      case CacheType.double:
        return _prefs!.setDouble(key, value);
      case CacheType.string:
        return _prefs!.setString(key, value);
      case CacheType.stringList:
        return _prefs!.setStringList(key, value);

      default:
        return await _prefs!.setString(key, value);
    }
  }

  static _get<T>(CacheType type, String key, {T? defValue}){
    if(!isNotNull(_prefs)) return defValue;
    switch(type){
      case CacheType.bool:
        return _prefs!.getBool(key) ?? defValue;
      case CacheType.json:
        String? tmp = _prefs!.getString(key);
        Map? map = !isNotNull(tmp) ? null : json.decode(tmp!);
        return map ?? defValue;
      case CacheType.string:
        return _prefs!.getString(key) ?? defValue;
      case CacheType.int:
        return _prefs!.getInt(key) ?? defValue;
      case CacheType.double:
        return _prefs!.getDouble(key) ?? defValue;
      case CacheType.stringList:
        return _prefs!.getStringList(key) ?? defValue;

      default:
        return _prefs!.getString(key) ?? defValue;
    }
  }

  static Future<bool> setJson(String key, Object? value) async => _set(CacheType.json, key, value);
  static Future<bool> setBool(String key, bool? value) async => _set(CacheType.bool, key, value);
  static Future<bool> setString(String key, String? value) async => _set(CacheType.string, key, value);
  static Future<bool> setInt(String key, int? value) async => _set(CacheType.int, key, value);
  static Future<bool> setDouble(String key, double? value) async => _set(CacheType.double, key, value);
  static Future<bool> setStringList(String key,  List<String>? value) async => _set(CacheType.stringList, key, value);

  static Map getJson<T>(String key, {T? defValue})  => _get(CacheType.json, key, defValue: defValue) as Map;
  static bool getBool(String key, {bool? defValue})  => _get(CacheType.bool, key, defValue: defValue) as bool;
  static String getString(String key, {String? defValue})  => _get(CacheType.string, key, defValue: defValue) as String;
  static int getInt(String key, {int? defValue})  => _get(CacheType.int, key, defValue: defValue) as int;
  static double getDouble(String key, {double? defValue})  => _get(CacheType.double, key, defValue: defValue) as double;
  static List<String> getStringList(String key, {List<String>? defValue})  => _get(CacheType.stringList, key, defValue: defValue) as List<String>;

  static remove(String key) => _prefs?.remove(key);
  static clear() => _prefs?.clear();
}