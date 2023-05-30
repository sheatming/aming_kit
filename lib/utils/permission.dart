import '../aming_kit.dart';
export 'package:permission_handler/permission_handler.dart';

//post_install do |installer|
//   installer.pods_project.targets.each do |target|
//     flutter_additional_ios_build_settings(target)
//
//     target.build_configurations.each do |config|
//       config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
//         '$(inherited)',
//         'PERMISSION_EVENTS=1',
//         'PERMISSION_REMINDERS=1',
//         'PERMISSION_CONTACTS=1',
//         'PERMISSION_CAMERA=1',
//         'PERMISSION_MICROPHONE=1',
//         'PERMISSION_SPEECH_RECOGNIZER=1',
//         'PERMISSION_PHOTOS=1',
//         'PERMISSION_LOCATION=1',
//         'PERMISSION_NOTIFICATIONS=1',
//         'PERMISSION_MEDIA_LIBRARY=1',
//         'PERMISSION_SENSORS=1',
//         'PERMISSION_BLUETOOTH=1',
//         'PERMISSION_APP_TRACKING_TRANSPARENCY=1',
//         'PERMISSION_CRITICAL_ALERTS=1'
//       ]
//     end
//   end
// end

class OuiPermissionItem {
  final String name;
  final IconData icon;
  final bool platform;
  OuiPermissionItem({this.name = "", this.icon = Icons.warning, this.platform = false});
}

class OuiPermission {
  static double? borderRadius;

  static Map<Permission, OuiPermissionItem> cn = {
    Permission.microphone: OuiPermissionItem(name: "麦克风", icon: Icons.mic_rounded, platform: isIOS || isAndroid),
    Permission.camera: OuiPermissionItem(name: "摄像头", icon: Icons.camera_alt_outlined, platform: isIOS || isAndroid),
    Permission.bluetooth: OuiPermissionItem(name: "蓝牙", icon: Icons.bluetooth, platform: isIOS),
    Permission.contacts: OuiPermissionItem(name: "联系人", icon: Icons.contacts, platform: isIOS || isAndroid),
    Permission.calendar: OuiPermissionItem(name: "日历", icon: Icons.calendar_month, platform: isIOS || isAndroid),
    Permission.photos: OuiPermissionItem(name: "照片", icon: Icons.calendar_month, platform: isIOS || isAndroid),
    Permission.speech: OuiPermissionItem(name: isAndroid ? "麦克风" : "演讲", icon: Icons.mic_rounded, platform: isIOS || isAndroid),
  };

  static Future<void> calendar({
    required Function onHandle,
    required String description,
    IconData? iconData,
    String? title,
    Function? onError,
    PermissionDecoration? decoration,
  }) async =>
      check(
        permission: Permission.calendar,
        onHandle: onHandle,
        iconData: iconData ?? Icons.calendar_month,
        title: title ?? "获取日历权限",
        description: description,
        onError: onError,
        decoration: decoration,
      );

  static Future<void> camera({
    required Function onHandle,
    required String description,
    IconData? iconData,
    String? title,
    Function? onError,
    PermissionDecoration? decoration,
  }) async =>
      check(
        permission: Permission.camera,
        onHandle: onHandle,
        iconData: iconData ?? Icons.camera_alt_outlined,
        title: title ?? "获取相机权限",
        description: description,
        onError: onError,
        decoration: decoration,
      );

  static Future<void> contacts({
    required Function onHandle,
    required String description,
    IconData? iconData,
    String? title,
    Function? onError,
    PermissionDecoration? decoration,
  }) async =>
      check(
        permission: Permission.contacts,
        onHandle: onHandle,
        iconData: iconData ?? Icons.camera_alt_outlined,
        title: title ?? "获取通讯录权限",
        description: description,
        onError: onError,
        decoration: decoration,
      );

  static Future<void> check({
    required permission,
    required Function onHandle,
    required IconData? iconData,
    required String title,
    required String description,
    Function? onError,
    PermissionDecoration? decoration,
  }) async {
    if (isNotNull(permission)) {
      if (permission is Permission) {
        // PermissionStatus status = await permission.status;
        return _check(
          permission,
          granted: () => onHandle(),
          denied: () => _request(
            permission: permission,
            onHandle: onHandle,
            onError: onError,
            decoration: decoration,
            iconData: iconData,
            title: title,
            description: description,
          ),
        );
      } else if (permission is List<Permission>) {
        int _granted = 0;
        int _denied = 0;
        int _permanentlyDenied = 0;
        print("re");
        for (var value in permission) {
          await _check(
            value,
            granted: () => _granted++,
            denied: () => _denied++,
            permanentlyDenied: () => _permanentlyDenied++,
          );
        }
        if (_denied == 0 && _granted == permission.length) {
          if (isNotNull(onHandle)) onHandle();
        }
        if (_permanentlyDenied > 0) {
          toast("权限未授权");
        } else {
          return _request(
            permission: permission,
            onHandle: onHandle,
            onError: onError,
            decoration: decoration,
            iconData: iconData,
            title: title,
            description: description,
          );
        }
        print(_permanentlyDenied);

        // Map<Permission, PermissionStatus> status = await permission.();
        // status.forEach((key, value) {});
        // await _check(
        //   status,
        //   granted: () => onHandle(),
        //   denied: () => _request(
        //     permission: element,
        //     onHandle: onHandle,
        //     onError: onError,
        //     decoration: decoration,
        //     iconData: iconData,
        //     title: title,
        //     description: description,
        //   ),
        // );
      } else {
        toast("请求失败");
        if (isNotNull(onError)) onError!();
      }
    } else {
      toast("请求失败");
      if (isNotNull(onError)) onError!();
    }
  }

  static Future<void> _check(
    Permission permission, {
    Function? granted,
    Function? denied,
    Function? limited,
    Function? permanentlyDenied,
    Function? restricted,
  }) async {
    PermissionStatus status = await permission.status;
    switch (status) {
      case PermissionStatus.granted:
        if (isNotNull(granted)) granted!();
        print("granted");
        break;
      case PermissionStatus.denied:
        if (isNotNull(denied)) denied!();
        print("denied :");
        print("未申请的时候");
        break;
      case PermissionStatus.limited:
        if (isNotNull(limited)) limited!();
        print("limited");
        break;
      case PermissionStatus.permanentlyDenied:
        if (isNotNull(permanentlyDenied)) permanentlyDenied!();
        print("permanentlyDenied :");
        print("字面意思 永久拒绝");
        print("申请时关闭请求对话框");
        break;
      case PermissionStatus.restricted:
        if (isNotNull(restricted)) restricted!();
        print("restricted");
        break;
    }
  }

  static Future<void> _request({
    required permission,
    required Function onHandle,
    required String title,
    required String description,
    Function? onError,
    IconData? iconData,
    PermissionDecoration? decoration,
  }) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: OuiGlobal.globalContext!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, state) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 50.px),
              decoration: (decoration?.boxDecoration ?? BoxDecoration()).copyWith(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.px),
                  topRight: Radius.circular(30.px),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                        (decoration?.iconBackgroundColor ?? OuiTheme.data()!.primaryColor),
                        (decoration?.iconBackgroundColor ?? OuiTheme.data()!.primaryColor).lighten(20),
                      ]),
                    ),
                    child: Center(
                      child: Icon(iconData ?? Icons.perm_identity_sharp, size: 40, color: (decoration?.iconBackgroundColor ?? OuiTheme.data()!.primaryColor).lighten(40)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(title, style: decoration?.titleStyle ?? OuiTheme.data()!.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: decoration?.titleStyle?.copyWith(
                      height: 3.px,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  OuiButton(
                    margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    radius: decoration?.buttonBorderRadius,
                    backgroundColor: decoration?.buttonBackgroundColor,
                    child: Text(decoration?.buttonText ?? "申请权限"),
                    onClick: () async {
                      goback();
                      if (permission is Permission) {
                        if (cn[permission]?.platform == false) return onHandle();
                        await permission.request();
                        _check(
                          permission,
                          granted: () => onHandle(),
                          denied: onError ?? () => toast(decoration?.deniedText ?? "${cn[permission]?.name ?? ""}拒绝开启"),
                          permanentlyDenied: onError ?? () => toast(decoration?.permanentlyDeniedText ?? "${cn[permission]?.name ?? ""}拒绝开启"),
                        );
                      } else if (permission is List<Permission>) {
                        Map<Permission, PermissionStatus> statuses = await permission.request();

                        // check(
                        //   permission: permission,
                        //   onHandle: onHandle,
                        //   iconData: iconData,
                        //   title: title,
                        //   description: description,
                        // );

                        for (var key in statuses.keys) {
                          var value = statuses[key];
                          if (value != PermissionStatus.granted && cn[key]?.platform == true) {
                            print("${key}   ${value}");
                            _check(
                              key,
                              granted: () => onHandle(),
                              denied: onError ?? () => toast(decoration?.deniedText ?? "${cn[key]?.name ?? ""}拒绝开启"),
                              permanentlyDenied: onError ?? () => toast(decoration?.permanentlyDeniedText ?? "${cn[key]?.name ?? ""}$key拒绝开启"),
                            );
                            return;
                          }
                        }
                        // statuses.forEach((key, value) {
                        //   // print("${key} ---  ${value}");
                        // });
                      }
                    },
                  ),
                  OuiButton(
                    show: decoration?.showCancelButton,
                    margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    radius: decoration?.buttonBorderRadius,
                    backgroundColor: decoration?.cancelButtonBackgroundColor ?? Colors.transparent,
                    child: Text(
                      "暂不开启",
                      style: OuiTheme.bodyMedium,
                    ),
                    onClick: () async {
                      goback();
                    },
                  ),
                  const SizedBox(height: 20),
                  if (decoration?.showCancelButton == false) const SizedBox(height: 10),
                  const OuiSafeTouchBar(),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Future<bool> _checkPlatform() async{
//   if (isIOS) {
//     return permission != Permission.unknown &&
//         permission != Permission.sms &&
//         permission != Permission.storage &&
//         permission != Permission.ignoreBatteryOptimizations &&
//         permission != Permission.accessMediaLocation &&
//         permission != Permission.activityRecognition &&
//         permission != Permission.manageExternalStorage &&
//         permission != Permission.systemAlertWindow &&
//         permission != Permission.requestInstallPackages &&
//         permission != Permission.accessNotificationPolicy &&
//         permission != Permission.bluetoothScan &&
//         permission != Permission.bluetoothAdvertise &&
//         permission != Permission.bluetoothConnect;
//   } else {
//     return permission != Permission.unknown &&
//         permission != Permission.mediaLibrary &&
//         permission != Permission.photos &&
//         permission != Permission.photosAddOnly &&
//         permission != Permission.reminders &&
//         permission != Permission.appTrackingTransparency &&
//         permission != Permission.criticalAlerts;
//   }
// }
}

class PermissionDecoration {
  Color? iconBackgroundColor;
  Color? buttonBackgroundColor;
  Color? cancelButtonBackgroundColor;
  double? buttonBorderRadius;
  TextStyle? titleStyle;
  TextStyle? descriptionStyle;
  BoxDecoration? boxDecoration;
  String? buttonText;
  String? deniedText;
  String? permanentlyDeniedText;
  bool showCancelButton;

  PermissionDecoration({
    this.iconBackgroundColor,
    this.buttonBackgroundColor,
    this.cancelButtonBackgroundColor,
    this.buttonBorderRadius,
    this.titleStyle,
    this.descriptionStyle,
    this.boxDecoration,
    this.buttonText,
    this.deniedText,
    this.permanentlyDeniedText,
    this.showCancelButton = true,
  });
}
