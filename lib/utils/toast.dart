import 'package:aming_kit/aming_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OuiToast {

  static Future<void> toast({
    String? text,
    Duration? duration,
    EdgeInsetsGeometry? contentPadding,
    WrapAnimation? wrapAnimation,
    Color? contentColor,
    TextStyle? style,
    AlignmentGeometry? align = const Alignment(0, 0.8)
  }) async {
    BotToast.showText(
      duration: duration,
        text: text ?? "",
        align: align,
        wrapAnimation: wrapAnimation,
        onlyOne: true,
        contentPadding: contentPadding ?? const EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 7),
        contentColor: contentColor ?? const Color(0x50000000),
        textStyle: style ?? OuiTheme.bodyMedium!.copyWith(
          color: Colors.white,
        )
    );
  }

  static Future<void> close({
    bool animation = true,
  }) async {
    BotToast.cleanAll();
  }

  static Future<void> loading({
    String? text,
    Widget? indicator,
  }) async {
    // EasyLoading.show (
    //   status: text,
    //   indicator: indicator,
    //   maskType: maskType,
    //   dismissOnTap: dismissOnTap,
    // );
  BotToast.showLoading(
      wrapAnimation: (AnimationController controller, CancelFunc cancelFunc, Widget widget){
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: Container(
                decoration: const BoxDecoration(

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // constraints: BoxConstraints(
                          //   minWidth: 60,
                          //   minHeight: 60,
                          // ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15
                          ),
                          decoration: BoxDecoration(
                              color: const Color(0x50000000),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              indicator ?? const SpinKitCircle(
                                size: 40,
                                color: Colors.white,
                              ),
                              if(isNotNull(text))
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,

                                  ),
                                  child: Text(text!, style: OuiTheme.bodySmall?.copyWith(
                                      color: Colors.white
                                  ),),
                                ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
            ),
          ),
        );
      }
  );
}
}

Future<void> toast(text, {
  Duration? duration,
  EdgeInsetsGeometry? contentPadding,
  Color? contentColor,
  TextStyle? style,
  WrapAnimation? wrapAnimation,
}) async => OuiToast.toast(
  duration: duration ?? Duration(seconds: 2),
  text: text,
  wrapAnimation: wrapAnimation,
    contentPadding: contentPadding,
  contentColor: contentColor,
  style: style,
);

Future<void> showLoading({
  String? text,
  Widget? indicator,
}) async => OuiToast.loading(
  text: text,
  indicator: indicator,
);

Future<void> closeToast() async => OuiToast.close();