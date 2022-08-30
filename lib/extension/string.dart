extension OtherString on String{
  String add(object){
    return "${this}$object";
  }

  int get toInt{
    return int.parse(this);
  }

  double get toDouble{
    return double.parse(this);
  }

  String get first{
    return this[0];
  }

  String get last{
    return this[length -1];
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