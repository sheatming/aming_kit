import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';
export 'package:tinycolor2/tinycolor2.dart';

extension ExtColor on Color? {
  Color antiWhite({Color? lightColor = Colors.white, Color? darkColor = Colors.black, double threshold = 200}) {
    if(this == null) return Colors.transparent;
    bool get = TinyColor.fromColor(this!).getBrightness() > threshold;
    return get
        ? darkColor ?? TinyColor.fromColor(this!).darken(7).color
        : lightColor ?? TinyColor.fromColor(this!).lighten(7).color;
  }
}

Color randomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
  if (r == 0 || g == 0 || b == 0) return Colors.black;
  if (a == 0) return Colors.white;
  return Color.fromARGB(
    a,
    r != 255 ? r : Random.secure().nextInt(r),
    g != 255 ? g : Random.secure().nextInt(g),
    b != 255 ? b : Random.secure().nextInt(b),
  );
}