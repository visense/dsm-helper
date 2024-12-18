import 'package:dsm_helper/themes/app_theme.dart';
import 'package:dsm_helper/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

typedef Callback = Function();

class Button extends StatefulWidget {
  final Widget child;
  final Callback onPressed;
  final Color? borderColor;
  final double? borderRadius;
  final Color? color;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final Widget? icon;
  final bool fill;
  final bool loading;
  final bool disabled;
  const Button({
    required this.child,
    required this.onPressed,
    this.borderColor,
    this.borderRadius,
    this.color,
    this.padding,
    this.margin,
    this.textStyle,
    this.width,
    this.icon,
    this.fill = true,
    this.loading = false,
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 200);
  static const Duration kFadeInDuration = Duration(milliseconds: 200);
  final Tween<double> _opacityTween = Tween<double>(begin: 1, end: 0.6);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(_opacityTween);
    // _setTween();
  }

  @override
  void didUpdateWidget(Button old) {
    super.didUpdateWidget(old);
    // _setTween();
  }

  // void _setTween() {
  //   _opacityTween.end = 0.8;
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown && (!widget.loading && !widget.disabled)) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown ? _animationController.animateTo(1.0, duration: kFadeOutDuration) : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color fillColor = widget.color ?? AppTheme.of(context)?.primaryColor ?? Theme.of(context).primaryColor;
    Color defaultTextColor = widget.fill ? Colors.white : fillColor;
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.loading && !widget.disabled) {
          widget.onPressed();
        }
      },
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.fill
                ? widget.loading || widget.disabled
                    ? fillColor.withOpacity(0.6)
                    : fillColor
                : null,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 15),
            border: widget.borderColor == null ? null : Border.all(color: widget.borderColor!.withOpacity(widget.disabled ? 0.6 : 1), width: 1),
          ),
          padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: widget.margin,
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.loading)
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: LoadingWidget(
                      color: widget.textStyle?.color ?? defaultTextColor,
                      size: widget.textStyle?.fontSize ?? 16,
                    ),
                  )
                else if (widget.icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: _buildIcon(),
                  ),
                Flexible(
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: defaultTextColor.withOpacity(widget.disabled ? 0.6 : 1),
                    ).merge(widget.textStyle),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.icon is Icon) {
      Icon icon = widget.icon as Icon;
      return Icon(
        icon.icon,
        size: icon.size ?? widget.textStyle?.fontSize ?? 16,
      );
    } else if (widget.icon is Image) {
      Image icon = widget.icon as Image;
      return Image(
        image: icon.image,
        color: icon.color,
        width: icon.width ?? widget.textStyle?.fontSize ?? 16,
        height: icon.height ?? widget.textStyle?.fontSize ?? 16,
      );
    } else {
      return widget.icon ?? SizedBox();
    }
  }
}
