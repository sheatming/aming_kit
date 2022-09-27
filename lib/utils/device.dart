
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'common.dart';
import 'define.dart';
import 'log.dart';

class OuiDevice{

  static DeviceInfoPlugin? _deviceInfo;
  static AndroidDeviceInfo? _androidInfo;
  static IosDeviceInfo? _iosInfo;
  static AndroidId? _androidId;

  static String? brand;
  static String? model;
  static String? uuid;
  static bool? isPhysicalDevice;
  static String? osName;
  static String? osVersion;

  static Future<void> init() async{
    if(!isNotNull(_deviceInfo)) {
      _deviceInfo = DeviceInfoPlugin();
      log.system("initialization", tag: "DeviceInfo");
    }
    if(isIOS){
      if(!isNotNull(_iosInfo)) _iosInfo = await _deviceInfo?.iosInfo;
      brand = _iosInfo?.model;
      model = _iosInfo?.name;
      uuid = _iosInfo?.identifierForVendor;
      isPhysicalDevice = _iosInfo?.isPhysicalDevice;
      osName = "iOS";
      osVersion = _iosInfo?.systemVersion;
    } else if(isAndroid) {
      if(!isNotNull(_androidInfo)) _androidInfo = await _deviceInfo?.androidInfo;
      if(!isNotNull(_androidId)) _androidId = const AndroidId();
      brand = _androidInfo?.brand;;
      model = _androidInfo?.model;
      uuid = await _androidId?.getId();
      isPhysicalDevice = _androidInfo?.isPhysicalDevice;
      osName = "Android";
      osVersion = _androidInfo?.version.sdkInt.toString();
    }
  }
}