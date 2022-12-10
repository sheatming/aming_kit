import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class OuiGlobal{
  static bool initMaterialApp = false;
  static EventBus eventBus = EventBus();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get globalContext => navigatorKey.currentState?.overlay?.context;
}

FlutterError contextError = FlutterError(
'[context] 无效 \n'
'请在[MaterialApp]中将[OuiGlobal.navigatorKey]注册到[navigatorKey].\n'
"或直接使用[OuiMaterialApp] "
);