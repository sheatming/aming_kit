import 'package:aming_kit/aming_kit.dart';
import 'package:demo/pages/widget.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  Widget build(BuildContext context) {
    return pageBody(
      title: "权限",
      children: [
        OuiButton(
          onAsyncClick: () async {
            OuiPermission.check(
              onHandle: () {
                toast("执行此功能");
              },
              iconData: Icons.video_call,
              title: "扫一扫",
              description: "需要开启相机才可以使用扫一扫功能",
              permission: Permission.camera,
            );
          },
          child: Text("申请单个"),
        ),
        OuiButton(
          onAsyncClick: () async {
            OuiPermission.check(
              onHandle: () {
                toast("执行此功能");
              },
              iconData: Icons.video_call,
              title: "录制分享",
              description: "需要开启相机、麦克风以及联系人才可以使用录制分享功能",
              permission: [
                Permission.camera,
                Permission.microphone,
                Permission.contacts,
              ],
            );
          },
          child: Text("申请多个"),
        ),
      ],
    );
  }
}
