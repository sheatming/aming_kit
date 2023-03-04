import '../utils/common.dart';

extension ExtList on List{
  bool get isNull{
    return !isNotNull(this);
  }

  bool isFirst(value){
    var first = this.first;
    return value == first;
  }

  bool isLast(value){
    var last = this.last;
    return value == last;
  }
}