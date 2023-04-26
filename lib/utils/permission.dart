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


class OuiPermission{

  static double? borderRadius;

  bool? _isFirst;

  static Future<void> calendar({
    required Function onHandle,
    required String description,
    IconData? iconData,
    String? title,
    Function? onError,
    PermissionDecoration? decoration,
  }) async => check(
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
  }) async => check(
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
  }) async => check(
    permission: Permission.contacts,
    onHandle: onHandle,
    iconData: iconData ?? Icons.camera_alt_outlined,
    title: title ?? "获取通讯录权限",
    description: description,
    onError: onError,
    decoration: decoration,
  );


  static Future<void> check({
    required Permission permission,
    required Function onHandle,
    required IconData? iconData,
    required String title,
    required String description,
    Function? onError,
    PermissionDecoration? decoration,
  }) async{
    if(isNotNull(permission)){
      PermissionStatus status = await permission.status;
      return _check(status,
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
    } else {
      toast("请求失败");
      if(isNotNull(onError)) onError!();
    }

  }

  static Future<void> _check(PermissionStatus status, {
    Function? granted,
    Function? denied,
    Function? limited,
    Function? permanentlyDenied,
    Function? restricted,
  }) async{
    switch(status){
      case PermissionStatus.granted:
        if(isNotNull(granted)) granted!();
        print("granted");
        break;
      case PermissionStatus.denied:
        if(isNotNull(denied)) denied!();
        print("denied :");
        print("未申请的时候");
        break;
      case PermissionStatus.limited:
        if(isNotNull(limited)) limited!();
        print("limited");
        break;
      case PermissionStatus.permanentlyDenied:
        if(isNotNull(permanentlyDenied)) permanentlyDenied!();
        print("permanentlyDenied :");
        print("字面意思 永久拒绝");
        print("申请时关闭请求对话框");
        break;
      case PermissionStatus.restricted:
        if(isNotNull(restricted)) restricted!();
        print("restricted");
        break;
    }
  }

  static Future<void> _request({
    required Permission permission,
    required Function onHandle,
    required String title,
    required String description,
    Function? onError,
    IconData? iconData,
    PermissionDecoration? decoration,
  }) async{
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: OuiGlobal.globalContext!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, state){
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 50.px
              ),
              decoration: decoration?.boxDecoration?.copyWith(
                color: Colors.white,
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
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            (decoration?.iconBackgroundColor ?? OuiTheme.data()!.primaryColor),
                            (decoration?.iconBackgroundColor ?? OuiTheme.data()!.primaryColor).lighten(20),
                          ]
                      ),

                    ),

                    child: Center(
                      child: Icon(iconData ?? Icons.perm_identity_sharp, size: 40, color: (decoration?.iconBackgroundColor ?? OuiTheme.data()!.primaryColor).lighten(40)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(title, style: decoration?.titleStyle ?? OuiTheme.data()!.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold
                  )),
                  const SizedBox(height: 10),
                  Text(description, style: decoration?.titleStyle?.copyWith(
                      height: 3.px,
                  ), textAlign: TextAlign.center,),
                  OuiButton(
                    margin: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15
                    ),
                    radius: decoration?.buttonBorderRadius,
                    backgroundColor: decoration?.buttonBackgroundColor,
                    child: Text(decoration?.buttonText ?? "申请权限"),
                    onClick: () async{
                      goback();
                      _check(await permission.request(),
                        granted: () => onHandle(),
                        denied: onError ?? () => toast(decoration?.deniedText ?? "拒绝开启"),
                        permanentlyDenied: onError ?? () => toast(decoration?.permanentlyDeniedText ?? "拒绝开启"),
                      );
                    },
                  ),


                  OuiButton(
                    show: decoration?.showCancelButton,
                    margin: const EdgeInsets.only(
                        top: 5,
                        left: 15,
                        right: 15
                    ),
                    radius: decoration?.buttonBorderRadius,
                    backgroundColor: decoration?.cancelButtonBackgroundColor ?? Colors.transparent,
                    child: Text("暂不开启", style: OuiTheme.bodyMedium,),
                    onClick: () async{
                      goback();
                    },
                  ),
                  const SizedBox(height: 20),
                  if(decoration?.showCancelButton == false)
                    const SizedBox(height: 10),

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

class PermissionDecoration{
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