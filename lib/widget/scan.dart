import 'dart:ui';
import 'package:aming_kit/aming_kit.dart';
import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
import 'package:wakelock/wakelock.dart';

class OuiScan extends StatefulWidget{
  const OuiScan({Key? key,
    required this.types,
    this.appBar,
    this.child,
    this.title,
    this.onScan,
    this.onError,
    this.hintText,
  }):super(key: key);

  final Widget? child;
  final PreferredSizeWidget? appBar;
  final String? title;
  final String? hintText;
  final ValueChanged? onScan;
  final VoidCallback? onError;
  final List<BarcodeType> types;

  @override
  State<StatefulWidget> createState() => _OuiScan();
}

class _OuiScan extends State<OuiScan>{
  bool isFirst = true;
  double opacity = 1;
  final controller = CameraController();

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
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
                opacity: opacity,
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
    return SizedBox(
      height: MediaQueryData.fromWindow(window).size.height,
      child: OverflowBox(
        alignment: Alignment.center,
        maxHeight: MediaQueryData.fromWindow(window).size.height,
        maxWidth: MediaQueryData.fromWindow(window).size.width + kToolbarHeight + MediaQueryData.fromWindow(window).padding.top + MediaQueryData.fromWindow(window).padding.bottom,
        child: BarcodeCamera(
          types: widget.types,
          resolution: Resolution.hd720,
          framerate: Framerate.fps30,
          position: CameraPosition.back,
          mode: DetectionMode.pauseDetection,
          onScan: (code) {
            if(isNotNull(code.value)){
              if(isNotNull(widget.onScan)){
                widget.onScan!(code.value);
              }
            } else {
              if(isNotNull(widget.onError)){
                widget.onError!();
              }
            }
          },
          onError: (context, err) {
            if(isNotNull(widget.onError)){
              widget.onError!();
            }
            return Container();
          },
          children: const [
            BlurPreviewOverlay(),
          ],
        ),
      ),
    );
  }
}