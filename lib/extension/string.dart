import 'dart:convert';
import 'dart:core';
import 'package:aming_kit/utils/validator.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import '../utils/common.dart';

extension OtherString on String{
  String add(object){
    return "${this}$object";
  }

  int get toInt{
    if(!isNotNull(this)) return 0;
    return int.parse(this);
  }

  double get toDouble{
    return double.parse(this);
  }

  String get first{
    if(length > 0){
      return this[0];
    } else {
      return this;
    }

  }

  String get last{
    return this[length -1];
  }

  bool get isNull{
    return !isNotNull(this);
  }

  String get toMd5{
    var content = const Utf8Encoder().convert(this);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }


  Map get toMap{
    if(!isNotNull(this)) return {};
    List<String> urlArr = Uri.decodeComponent(this).split("&");
    Map tmpMap = {};
    for (var item in urlArr) {
      var tmpParams = item.split("=");
      tmpMap.addAll({tmpParams[0]: tmpParams[1]});
    }
    return tmpMap;
  }
}

//删除扩展
extension RemoveString on String {
  //删除第一个字符
  String get removeFirst{
    String tmp = "";
    for(int i=0; i<length; i++){
      if(i > 0){
        tmp = tmp.add(this[i]);
      }
    }
    return tmp;
  }

  //删除最后一个字符
  String get removeLast{
    String tmp = "";
    for(int i=0; i<length-1; i++){
      tmp = tmp.add(this[i]);
    }
    return tmp;
  }
}

extension RegExpString on String{
  bool get isMobile{
    return OuiValidator.isMobile(this);
  }
  bool get isEmail{
    return OuiValidator.isEmail(this);
  }
  bool get isUrl{
    return OuiValidator.isUrl(this);
  }
}