import '../aming_kit.dart';
export 'package:permission_handler/permission_handler.dart';

class OuiPermission{

  static double? borderRadius;

  bool? _isFirst;

  static Future<void> check({
    required Permission permission,
    required Function onHandle,
    required IconData? iconData,
    required String title,
    required String description,
    Function? onError,
    PermissionDecoration? decoration,
  }) async{
    PermissionStatus _status = await permission.status;
    print("当前权限 $_status");
    _check(_status,
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
                    margin: EdgeInsets.only(
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
                    margin: EdgeInsets.only(
                        top: 5,
                        left: 15,
                        right: 15
                    ),
                    radius: decoration?.buttonBorderRadius,
                    backgroundColor: decoration?.cancelButtonBackgroundColor ?? Colors.transparent,
                    child: Text("暂不开启"),
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