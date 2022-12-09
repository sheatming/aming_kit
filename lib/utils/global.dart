import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class OuiGlobal{
  static bool initMaterialApp = false;
  static EventBus eventBus = EventBus();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get globalContext => navigatorKey.currentState?.overlay?.context;
}