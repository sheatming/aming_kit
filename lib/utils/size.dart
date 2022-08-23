import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


double px(double size) => OuiSize.px(size);

extension SizeNumber on num{
  double get px{
    return OuiSize.px(this);
  }
}

class OuiSize {
  // static MediaQueryData mediaQuery;
  static late MediaQueryData mediaQuery;
  static final double _width = mediaQuery.size.width;
  static final double _height = mediaQuery.size.height;
  static final double _topbarHeight = mediaQuery.padding.top;
  static final double _botbarHeight = mediaQuery.padding.bottom;
  static final double _pixelRatio = mediaQuery.devicePixelRatio;
  static var _ratio;
  static init([double number = 750]){
    mediaQuery = MediaQueryData.fromWindow(window);
    double uiWidth = number;
    _ratio = _width / uiWidth;
    log.system("initialization", tag: "Size");
  }

  static Size size(){
    return mediaQuery.size;
  }

  static px(number){
    if(!(_ratio is double || _ratio is double)) init(750);
    return number * _ratio;
  }

  static onePx(){
    return 1 / _pixelRatio;
  }

  static screenWidth(){
    return _width;
  }

  static screenHeight(){
    return _height;
  }

  static padTopHeight(){
    return _topbarHeight;
  }

  static padBotHeight(){
    return _botbarHeight;
  }

  static statusBarHeight(){
    return mediaQuery.padding.top;
  }

  static touchBarHeight(){
    return mediaQuery.padding.bottom;
  }

  static toolBarHeight(){
    return kToolbarHeight;
  }
}

