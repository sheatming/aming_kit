extension OtherString on String{
  String add(object){
    return "${this}$object";
  }
}

//删除扩展
extension RemoveString on String {
  //删除第一个字符
  String removeFirst(){
    String tmp = "";
    for(int i=0; i<length; i++){
      if(i > 0){
        tmp = tmp.add(this[i]);
      }
    }
    return tmp;
  }

  //删除最后一个字符
  String removeLast(){
    String tmp = "";
    for(int i=0; i<length-1; i++){
      tmp = tmp.add(this[i]);
    }
    return tmp;
  }
}