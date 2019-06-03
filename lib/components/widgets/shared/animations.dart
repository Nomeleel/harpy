import 'package:flutter/material.dart';

/// Slides and fades its child into position upon creation.
class SlideFadeInAnimation extends StatefulWidget {
  const SlideFadeInAnimation({
    Key key,
    this.duration = const Duration(seconds: 1),
    this.delay = Duration.zero,
    this.offset = Offset.zero,
    this.skipIntroAnimation = false,
    this.finishCallback,
    @required this.child,
  }) : super(key: key);

  /// The duration of the animation.
  final Duration duration;

  /// The delay until the animation starts.
  final Duration delay;

  /// The offset that the child will have before it slides into position.
  final Offset offset;

  /// Skips the intro animation if set to `true`.
  final bool skipIntroAnimation;

  /// An optional callback when the animation has completed.
  final VoidCallback finishCallback;

  /// The child to animate.
  final Widget child;

  @override
  _SlideFadeInAnimationState createState() => _SlideFadeInAnimationState();
}

class _SlideFadeInAnimationState extends State<SlideFadeInAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.skipIntroAnimation) {
      _controller.value = 1.0;
    }

    // callback when animation has completed
    if (widget.finishCallback != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.finishCallback();
        }
      });
    }

    _animation = CurveTween(curve: Curves.fastOutSlowIn).animate(_controller)
      ..addListener(() => setState(() {}));

    if (widget.delay != Duration.zero) {
      Future.delayed(widget.delay).then((_) => _controller.forward());
    } else {
      _controller.forward();
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(
          (1 - _animation.value) * widget.offset.dx,
          (1 - _animation.value) * widget.offset.dy,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Fades out upon creation.
class FadeOutWidget extends StatefulWidget {
  const FadeOutWidget({
    Key key,
    this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  _FadeOutWidgetState createState() => _FadeOutWidgetState();
}

class _FadeOutWidgetState extends State<FadeOutWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..forward();
  }

  @override
  void deactivate() {
    _controller.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeOutWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.isAnimating
        ? Opacity(
            opacity: 1.0 - _controller.value,
            child: widget.child,
          )
        : Container();
  }
}
