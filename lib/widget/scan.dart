import 'dart:ui';
import 'package:aming_kit/aming_kit.dart';
import 'package:r_scan/r_scan.dart';
import 'package:wakelock/wakelock.dart';

class OuiScan extends StatefulWidget{
  const OuiScan({Key? key,
    this.appBar,
    this.continuous = false,
    this.child,
    this.title,
    this.onScan,
    this.hintText,
  }):super(key: key);

  final bool continuous;
  final Widget? child;
  final PreferredSizeWidget? appBar;
  final String? title;
  final String? hintText;
  final ValueChanged? onScan;

  @override
  State<StatefulWidget> createState() => _OuiScan();
}

class _OuiScan extends State<OuiScan>{
  List<RScanCameraDescription>? rScanCameras;
  RScanCameraController? _controller;
  bool isFirst = true;
  double _opacity = 1;

  void initCamera() async{
    rScanCameras = await availableRScanCameras();
    setTimeout((){
      if(mounted){
        setState(() {
          _opacity = 0;
        });
      }
    }, time: 5000);

    if(isNotNull(rScanCameras)){
      _controller = RScanCameraController(rScanCameras![0], RScanCameraResolutionPreset.max)
        ..addListener(() {
          if(!widget.continuous){
            final result = _controller?.result;
            if (result != null) {
              if (isFirst) {
                isFirst = false;
                if(isNotNull(widget.onScan)) widget.onScan!(result.message);
              }
            }
          } else {
            final result = _controller?.result;
            if (result != null) {
              if(widget.onScan != null) widget.onScan!(result.message);
            }
          }
        })
        ..initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
    }

  }

  @override
  void initState() {
    Wakelock.enable();
    // _alignment = _start;
    initCamera();
    super.initState();

    // setTimeout(() => setState((){
    //   _alignment = _end;
    // }), time: 100);
  }

  @override
  void dispose() {
    // _controller?.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  void didUpdateWidget(OuiScan oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _widget(),


          Padding(
            padding: EdgeInsets.only(
              bottom: OuiSize.touchBarHeight() + 100.px,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: _opacity,
                curve: Curves.easeInOut,
                child: Text(widget.hintText ?? "",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ),



          Offstage(
            offstage: widget.appBar != null,
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.appBar ?? AppBar(
                    title: Text(widget.title ?? ""),
                    backgroundColor: Colors.transparent,
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  if(isNotNull(widget.child)) widget.child!,
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }


  Widget _widget(){
      if(isNotNull(rScanCameras) && isNotNull(_controller)){
        if(_controller?.value.isInitialized == true){
          return SizedBox(
            height: MediaQueryData.fromWindow(window).size.height,
            width: _controller!.value.previewSize?.width,
            child: OverflowBox(
              alignment: Alignment.center,
              maxHeight: MediaQueryData.fromWindow(window).size.height,
              maxWidth: MediaQueryData.fromWindow(window).size.width + kToolbarHeight + MediaQueryData.fromWindow(window).padding.top + MediaQueryData.fromWindow(window).padding.bottom,
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: RScanCamera(_controller!),
              ),
            ),
          );
        } else {
          return Container();
        }
      } else {
        return Container();
      }

  }

  Future<bool?> getFlashMode() async {
    bool? isOpen = false;
    try {
      isOpen = await _controller!.getFlashMode();
    } catch (_) {}
    return isOpen;
  }

  // Widget _buildFlashBtn(BuildContext context, AsyncSnapshot<bool> snapshot) {
  //   return snapshot.hasData
  //       ? Padding(
  //     padding:  const EdgeInsets.only(
  //         bottom: 12
  //     ),
  //     child: GestureDetector(
  //       onTap: (){
  //         if (snapshot.data == true) {
  //           _controller!.setFlashMode(false);
  //         } else {
  //           _controller!.setFlashMode(true);
  //         }
  //         setState(() {});
  //       },
  //       child: Container(
  //         color: Colors.transparent,
  //         child: AnimatedCrossFade(
  //           duration: Duration(milliseconds: 200),
  //           crossFadeState: snapshot.data == true ? CrossFadeState.showSecond : CrossFadeState.showFirst,
  //           firstChild: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: const <Widget>[
  //               Icon(Icons.light_mode, size: 26, color: Colors.grey),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     top: 5
  //                 ),
  //                 child: Text('轻触点亮',
  //                   style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.grey
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           secondChild: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: const [
  //               Icon(Icons.light_mode_outlined, size: 26, color: Colors.grey),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     top: 5
  //                 ),
  //                 child: Text('轻触关闭',
  //                   style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.grey
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   )
  //       : Container();
  // }


}