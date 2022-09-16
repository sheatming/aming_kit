import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/material.dart';


class OuiApp{
  static Future<void> init() async {
    await OuiCache.init();
  }
}