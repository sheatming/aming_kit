import 'package:aming_kit/aming_kit.dart';

class OuiTheme{
  static ThemeData? data([BuildContext? context]) {
    BuildContext? tmpContext = context ?? OuiGlobal.globalContext;
    if(!isNotNull(tmpContext)) throw contextError;
    return Theme.of(tmpContext!);
  }

  static TextTheme? get textTheme => data()?.textTheme;
  static TextStyle? get bodyLarge => textTheme?.bodyLarge;
  static TextStyle? get bodySmall => textTheme?.bodySmall;
  static TextStyle? get bodyMedium => textTheme?.bodyMedium;
}
