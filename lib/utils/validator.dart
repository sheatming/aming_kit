
import 'common.dart';

class OuiValidator{
  static bool isMobile(value) {
    if(!isNotNull(value)) return false;
    if(value.length != 11) return false;

    const String regexEmail = "((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}\$";
    RegExp exp = RegExp(regexEmail);
    return exp.hasMatch(value);
  }

  static bool isEmail(value){
    if(!isNotNull(value)) return false;

    const String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    RegExp exp = RegExp(regexEmail);
    return exp.hasMatch(value);
  }
}