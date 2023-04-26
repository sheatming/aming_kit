import '../utils/common.dart';

extension ExtMap on Map{
  String get toUrl{
    if(!isNotNull(this)) return "";
    List<String> urlArr = [];
    forEach((key, value) {
      // urlArr.add("$key=$value}");
      urlArr.add("$key=${value.runtimeType == String ? Uri.encodeComponent(value) : value}");
    });
    return urlArr.join("&");
  }
}