
import 'common.dart';

class OuiValidator{
  static const String regexMobile = "((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}\$";
  static const String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  static const String regexUrl = "^((https|http|ftp|rtsp|mms)?://)[^s]+";
  static const String regexFileUrl = "^((file)?://)[^s]+";

  static bool isMobile(value) {
    if(!isNotNull(value)) return false;
    if(value.length != 11) return false;
    RegExp exp = RegExp(regexMobile);
    return exp.hasMatch(value);
  }

  static bool isEmail(value){
    if(!isNotNull(value)) return false;
    RegExp exp = RegExp(regexEmail);
    return exp.hasMatch(value);
  }

  static bool isUrl(value){
    if(!isNotNull(value)) return false;
    RegExp exp = RegExp(regexUrl);
    return exp.hasMatch(value);
  }

  static bool isFileUrl(value){
    if(!isNotNull(value)) return false;
    RegExp exp = RegExp(regexFileUrl);
    return exp.hasMatch(value);
  }
}