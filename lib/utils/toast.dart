import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

class OuiToast {

  static EasyLoading get instance => EasyLoading.instance;


  static Future<void> toast(text, {
    Duration? duration,
    EasyLoadingToastPosition? toastPosition,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) async => EasyLoading.showToast(text.toString(),
    duration: duration,
    toastPosition: toastPosition ?? EasyLoadingToastPosition.center,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );

  static Future<void> close({
    bool animation = true,
  }) async => EasyLoading.dismiss(animation: animation);

  static Future<void> loading({
    String? text,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
  }) async => EasyLoading.show(
    status: text,
    indicator: indicator,
    maskType: maskType,
    dismissOnTap: dismissOnTap,
  );

}

Future<void> toast(text, {
  Duration? duration,
  EasyLoadingToastPosition? toastPosition,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) async => OuiToast.toast(text,
  duration: duration,
  toastPosition: toastPosition ?? EasyLoadingToastPosition.bottom,
  maskType: maskType,
  dismissOnTap: dismissOnTap,
);

Future<void> showLoading({
  String? text,
  Widget? indicator,
  EasyLoadingMaskType? maskType,
  bool? dismissOnTap,
}) async => OuiToast.loading(
  text: text,
  indicator: indicator,
  maskType: maskType,
  dismissOnTap: dismissOnTap,
);