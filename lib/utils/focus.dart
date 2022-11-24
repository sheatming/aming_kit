
import 'package:aming_kit/aming_kit.dart';

class OuiFocus{
  static Future<void> requestFocus(FocusNode focusNode) async{
    return FocusScope.of(OuiGlobal.globalContext!).requestFocus(focusNode);
  }
}