library aming_kit;

import 'dart:io';
import 'package:flutter/foundation.dart';


export './extension/color.dart';
export './extension/number.dart';
export './extension/string.dart';

export './tools/debug.dart';

export './utils/cache.dart';
export './utils/common.dart';
export './utils/date.dart';
export './utils/global.dart';
export './utils/http.dart';
export './utils/log.dart';
export './utils/router.dart';
export './utils/size.dart';
export './utils/time.dart';
export './utils/timeline.dart';


/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}


bool isDebug = kDebugMode;
bool isProfile = kProfileMode;
bool isRelease = kReleaseMode;

bool isIOS = Platform.isIOS;
bool isAndroid = Platform.isAndroid;
