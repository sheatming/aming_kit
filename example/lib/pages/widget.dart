import 'package:aming_kit/aming_kit.dart';

Widget pageBody({String? title, List<Widget>? children}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title ?? ""),
    ),
    body: ListView(
      children: children ?? [],
    ),
  );
}
