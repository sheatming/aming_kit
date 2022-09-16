import '../utils/common.dart';
import '../utils/date.dart';
import '../utils/timeline.dart';

extension ExtNum on num {
  String toTime({String defValue = "-", bool isTimeLine = false, DayFormat? dayFormat, String? format}) => _toTime(
    this,
    defValue: defValue,
    isTimeLine: isTimeLine,
    dayFormat: dayFormat,
    format: format,
  );

  String toMoney([int fractionDigits = 2]){
    return isNotNull(this) ? (this / 100).toStringAsFixed(fractionDigits) : 0.toStringAsFixed(fractionDigits);
  }

  bool get isNull{
    return !isNotNull(this);
  }
}

extension ExtInt on int {
  List<int> get toList{
    List<int> t = [];
    for(int i=0; i<=this; i++){
      t.add(i);
    }
    return t;
  }
}


String _toTime(value, {String defValue = "-", bool isTimeLine = false, DayFormat? dayFormat, String? format}){
  num oldString;
  if(value == 0){
    return defValue;
  } else {
    oldString = value;
  }

  int oldInt = oldString.toInt();
  if(oldInt <= 9999999999){
    oldInt *= 1000;
  }

  if(isTimeLine){
    return TimelineUtil.format(oldInt, locale: "zh", dayFormat: isNotNull(dayFormat) ? dayFormat : DayFormat.full);
  } else {
    return DateUtil.formatDateMs(oldInt, format: format);
  }
}