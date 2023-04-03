import 'package:aming_kit/aming_kit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OuiToast {

  static Future<void> toast({
    String? text,
    Duration? duration,
    EdgeInsetsGeometry? contentPadding,
    WrapAnimation? wrapAnimation,
    Color? contentColor,
    TextStyle? style,
  }) async {
    BotToast.showText(
        text: text ?? "",
        wrapAnimation: wrapAnimation,
        onlyOne: true,
        contentPadding: contentPadding ?? EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 7),
        contentColor: contentColor ?? Color(0x50000000),
        textStyle: style ?? OuiTheme.bodyMedium!.copyWith(
          color: Colors.white,
        )!
    );
  }

  static Future<void> close({
    bool animation = true,
  }) async {
    BotToast.cleanAll();
    EasyLoading.dismiss(animation: animation);
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
                decoration: BoxDecoration(

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        indicator ?? Container(
                          // constraints: BoxConstraints(
                          //   minWidth: 60,
                          //   minHeight: 60,
                          // ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15
                          ),
                          decoration: BoxDecoration(
                              color: Color(0x50000000),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SpinKitCircle(
                                size: 40,
                                color: Colors.white,
                              ),
                              if(isNotNull(text))
                                Padding(
                                  padding: EdgeInsets.only(
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