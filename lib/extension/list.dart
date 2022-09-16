import '../utils/common.dart';

extension ExtList on List{
  bool get isNull{
    return !isNotNull(this);
  }
}