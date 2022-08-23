
import 'package:flutter/material.dart';

class OuiGlobal{
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get globalContext => navigatorKey.currentState?.overlay?.context;
}