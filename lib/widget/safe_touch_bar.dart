import 'package:aming_kit/aming_kit.dart';
class OuiSafeTouchBar extends StatelessWidget{
  const OuiSafeTouchBar({Key? key, this.backgroundColor = Colors.transparent, this.child}) : super(key: key);

  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      height: OuiSize.touchBarHeight(),
      child: child,
    );
  }
}