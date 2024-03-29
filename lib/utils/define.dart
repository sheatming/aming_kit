import 'dart:io';
import 'package:flutter/foundation.dart';

bool isDebug = kDebugMode;
bool isProfile = kProfileMode;
bool isRelease = kReleaseMode;

bool isIOS = Platform.isIOS;
bool isAndroid = Platform.isAndroid;
bool isMacOS = Platform.isMacOS;
bool isWindows = Platform.isWindows;
bool isWeb = kIsWeb;


