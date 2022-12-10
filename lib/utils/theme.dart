import 'package:aming_kit/aming_kit.dart';

class OuiTheme{
  static ThemeData? data([BuildContext? context]) {
    BuildContext? tmpContext = context ?? OuiGlobal.globalContext;
    if(!isNotNull(tmpContext)) throw contextError;
    return Theme.of(tmpContext!);
  }
}