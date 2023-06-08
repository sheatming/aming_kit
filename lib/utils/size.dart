import 'dart:ui';

import 'package:aming_kit/aming_kit.dart';

double px(double size) => OuiSize.px(size);

extension SizeNumber on num {
  double get px {
    return OuiSize.px(this);
  }
}

class OuiSize {
  // static MediaQueryData mediaQuery;
  static bool initialization = false;
  // static late MediaQueryData mediaQuery;
  static late FlutterView flutterView;
  static double get _width => flutterView.physicalSize.width;
  static double get _height => flutterView.physicalSize.height;
  static double get _topbarHeight => flutterView.padding.top;
  static double get _botbarHeight => flutterView.padding.bottom;
  static double get _pixelRatio => flutterView.devicePixelRatio;
  static double _ratio = 0;
  static double get ratio => _ratio;
  static init({double number = 750, bool isForce = false}) {
    if (!isForce) {
      if (initialization) {
        return;
      }
    }

    flutterView = WidgetsBinding.instance.platformDispatcher.views.first;
    // mediaQuery = MediaQueryData.fromView(window);
    double uiWidth = number;
    _ratio = _width / uiWidth;
    if (!initialization) log.system("initialization design size: $uiWidth screenWidth: $_width screenHeight: $_height", tag: "Size");
    initialization = true;
  }

  static Size size() {
    return flutterView.physicalSize;
  }

  static px(number) {
    if (!isNotNull(_ratio) || _ratio == 0) init(number: 750);
    return number * _ratio;
  }

  static onePx() {
    return 1 / _pixelRatio;
  }

  static screenWidth() {
    return _width;
  }

  static screenHeight() {
    return _height;
  }

  static padTopHeight() {
    return _topbarHeight;
  }

  static padBotHeight() {
    return _botbarHeight;
  }

  static statusBarHeight() {
    return _topbarHeight;
  }

  static touchBarHeight() {
    return _botbarHeight;
  }

  static toolBarHeight() {
    return kToolbarHeight;
  }
}
