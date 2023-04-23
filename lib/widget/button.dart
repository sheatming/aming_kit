import 'dart:io';
import 'package:aming_kit/aming_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OuiButton extends StatefulWidget{
  const OuiButton({Key? key,
    this.show,
    this.child,
    this.margin,
    this.contentPadding,
    this.radius,
    this.onClick,
    this.onAsyncClick,
    this.onLongClick,
    this.backgroundColor,
    this.borderColor,
    this.disabledColor,
    this.borderWidth,
    this.clickColor,
    this.elevation,
    this.loading=false,
    this.indicator,
    this.outline=false,
    this.enabled=true,
    this.height,
    this.width,
    this.autoClickTime = 0,
    this.onCount,
    this.showBorder,
  }):super(key: key);

  final bool? show;
  final Widget? child;
  final Widget? indicator;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final double? radius;
  final VoidCallback? onClick;
  final Future<void> Function()? onAsyncClick;
  final ValueChanged<bool>? onLongClick;
  final Function? onCount;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? disabledColor;
  final Color? clickColor;
  final bool loading;
  final bool outline;
  final bool? showBorder;
  final bool enabled;
  final double? borderWidth;
  final double? elevation;
  final double? height;
  final double? width;
  final int autoClickTime;

  @override
  State<StatefulWidget> createState() => _OuiButton();
}

class _OuiButton extends State<OuiButton>{

  Color? _bgc;
  Color? _bc;
  bool _tapStatus = false;

  bool _loading = false;

  void initBgColor(){
    setTimeout(() {
      if(mounted){
        setState(() {
          if(widget.enabled){
            _bgc = widget.backgroundColor ?? OuiTheme.data()!.primaryColor;
            _bc = widget.borderColor ?? _bgc;
          } else {
            _bgc = widget.disabledColor ?? OuiTheme.data()!.disabledColor;
            _bc = widget.borderColor ?? _bgc;
          }
        });
      }
    }, time: 5);
  }

  @override
  void initState() {
    super.initState();
    initBgColor();
  }

  @override
  void didUpdateWidget(OuiButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    initBgColor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.show == false){
      return Container();
    }
    return Padding(
      padding: widget.margin ?? const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15
      ),
      child: GestureDetector(
        onTap: (widget.enabled && !widget.loading) || !_loading ? () async{
          if(!widget.enabled) return;
          if(_loading) return;
          if(isNotNull(widget.onClick)){
            widget.onClick?.call();
            return;
          } else if(isNotNull(widget.onAsyncClick)){
            if(mounted) {
              setState(() {
                _loading = true;
              });
            }
            await widget.onAsyncClick!();
            if(mounted) {
              setState(() {
                _loading = false;
              });
            }
          }
        } : null,
        onTapDown: (res) => setState((){
          if(!widget.enabled || widget.loading) return;
          _tapStatus = true;
          if(_tapStatus == true && isNotNull(widget.onLongClick)){
            setTimeout((){
              widget.onLongClick!(_tapStatus);
            }, time: 500);
          }
        }),
        onTapUp: (res) => setState((){
          if(!widget.enabled || widget.loading) return;
          _tapStatus = false;
          if(isNotNull(widget.onLongClick)) widget.onLongClick!(_tapStatus);
        }),
        onTapCancel: () => setState((){
          if(!widget.enabled || widget.loading) return;
          _tapStatus = false;
          if(isNotNull(widget.onLongClick)) widget.onLongClick!(_tapStatus);
        }),
        child: Material(
          elevation: widget.elevation ?? 0,
          borderRadius: BorderRadius.circular(widget.radius ?? 6),
          animationDuration: const Duration(seconds: 0),
          color: Colors.transparent,
          textStyle: OuiTheme.bodyMedium!.copyWith(
            color: _textIconColor(),
          ),
          child: AnimatedContainer(
            padding: widget.contentPadding ?? EdgeInsets.zero,
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut,
            height: widget.height ?? 45,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius ?? 6),
              color: _backgroundColor(),
              border: (widget.outline && getData(widget.borderWidth, defValue: 1.0) > 0) || widget.showBorder == true ? Border.all(
                  color: _borderColor()!,
                  width: widget.borderWidth ?? 1
              ) : null,
            ),
            child: Center(
              child: AnimatedCrossFade(
                firstChild: IconTheme.merge(
                  data: IconThemeData(
                    color: _textIconColor(),
                  ),
                  child: DefaultTextStyle(
                    style: OuiTheme.bodyMedium!.copyWith(
                      color: _textIconColor(),
                    ),
                    child: widget.child ?? Container(),
                  ),
                ),
                secondChild: SpinKitWave(
                  color: _textIconColor(),
                  size: OuiTheme.bodyMedium!.fontSize!+5,
                  type: Platform.isIOS ? SpinKitWaveType.center : SpinKitWaveType.start,
                ),
                crossFadeState: _loading || widget.loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 150),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color? _backgroundColor(){
    if(_bgc == null) return Colors.transparent;
    if(!widget.enabled) {
      if(widget.outline) return Colors.transparent;
      return _bgc;
    }
    if(widget.outline){
      return !_tapStatus ? Colors.transparent : _bgc;
    }
    return _tapStatus ? (widget.clickColor ?? _bgc).antiWhite(
      lightColor: TinyColor.fromColor(_bgc!).darken(20).color,
      darkColor: TinyColor.fromColor(_bgc!).lighten(20).color,
    ) : _bgc;
  }

  Color? _borderColor(){
    if(_bc == null) return Colors.transparent;
    if(widget.outline){
      return _bc;
    }
    return _tapStatus ? _bc.antiWhite() : _bc;
  }

  Color? _textIconColor(){
    if(_bgc == Colors.transparent) return OuiTheme.bodyMedium?.color;
    if(_bgc == null) return Colors.transparent;
    if(!widget.enabled) return Colors.white;
    if(widget.outline){
      return _tapStatus ? _bgc.antiWhite(
        lightColor: Colors.white,
        darkColor: OuiTheme.bodyMedium!.color,
      ) : _bgc;
    }
    return _bgc.antiWhite(
        lightColor: Colors.white,
        darkColor: OuiTheme.bodyMedium!.color
    );
  }
}