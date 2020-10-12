import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// A widget that simultaneously fades and translates its
/// child in or out when its visibility is toggled.
class FadeAndTranslate extends StatefulWidget {
  /// A widget that simultaneously fades and translates its
  /// child in or out when its visibility is toggled.
  ///
  /// [child] is the widget being transitioned.
  ///
  /// [translate] is the offset the widget is being transitioned to when
  /// [visible] is set to `false`. When [visible] is `true`, the [child]
  /// is positioned at an offset of zero.
  ///
  /// [visible] is the current state of the transition.
  ///
  /// [duration] is the duration of both of fade and translate.
  ///
  /// [delay] is a [Duration] used to delay the start of the transition
  /// once it's been triggered.
  ///
  /// [curve] is used to apply a curve to transform the animations
  /// and affects both the fade and the translate.
  ///
  /// [autoStart], if `true`, will cause the transition to start as soon
  /// as the widget is built. [autoStart]'s transition will start from the
  /// state opposite of [visible], so if [visible] is `true`, the transition
  /// will auto-start from being hidden and become visible.
  ///
  /// [autoStartDelay] is used to delay the transition triggered by [autoStart]. It
  /// does not affect any transitions triggered by toggling [visible]. If [delay]
  /// isn't `null` and [autoStartDelay] is, [autoStartDelay] will inherit [delay]'s
  /// specified duration.
  ///
  /// [onStart] is a callback triggered at the start of the transition,
  /// when the animation reaches [AnimationStatus.dismissed].
  ///
  /// [onComplete] is a callback triggered when the transition has completed,
  /// when the animation reaches [AnimationStatus.completed].
  ///
  /// [maintainSize] sets whether to maintain space for where the widget would,
  /// have been when it is not [visible].
  ///
  /// [maintainState] sets whether to maintain the [State] objects of the [child]
  /// subtree when it is not [visible].
  const FadeAndTranslate({
    Key key,
    @required this.child,
    @required this.translate,
    this.visible = true,
    this.duration = const Duration(milliseconds: 120),
    this.delay,
    this.curve,
    this.autoStart = false,
    this.autoStartDelay,
    this.onStart,
    this.onComplete,
    this.maintainSize = false,
    this.maintainState = false,
  })  : assert(child != null),
        assert(translate != null),
        assert(visible != null),
        assert(duration != null),
        assert(autoStart != null),
        assert(maintainSize != null),
        assert(maintainState != null),
        super(key: key);

  /// The widget passed to the builder.
  final Widget child;

  /// The offset the child is translated to/from while fading in/out.
  final Offset translate;

  /// Switches between showing the [child] or hiding it.
  ///
  /// The `maintain` flags should be set to the same values regardless of the
  /// state of the [visible] property, otherwise they will not operate correctly
  /// (specifically, the state will be lost regardless of the state of
  /// [maintainState] whenever any of the `maintain` flags are changed, since
  /// doing so will result in a subtree shape change).
  ///
  /// Unless [maintainState] is set, the [child] subtree will be disposed
  /// (removed from the tree) while hidden.
  ///
  /// Copied from `Visibility`.
  final bool visible;

  /// The duration of the transition.
  final Duration duration;

  /// A [Duration] used to delay the start of the transition
  /// once it's been triggered.
  final Duration delay;

  /// The curve to use when transforming the value of the animation.
  ///
  /// Copied from `CurveTween`.
  final Curve curve;

  /// If `true`, the widget will start transitioning as soon as it's built.
  final bool autoStart;

  /// The duration to delay the transition triggered by [autoStart].
  final Duration autoStartDelay;

  /// A callback that's executed when the transition starts,
  /// when the animation reaches [AnimationStatus.dismissed].
  final Function onStart;

  /// A callback that's executed when the transition is completed,
  /// when the animation reaches [AnimationStatus.completed].
  final Function onComplete;

  /// Whether to maintain space for where the widget would have been.
  ///
  /// To set this, [maintainAnimation] and [maintainState] must also be set.
  ///
  /// Maintaining the size when the widget is not [visible] is not notably more
  /// expensive than just keeping animations running without maintaining the
  /// size, and may in some circumstances be slightly cheaper if the subtree is
  /// simple and the [visible] property is frequently toggled, since it avoids
  /// triggering a layout change when the [visible] property is toggled. If the
  /// [child] subtree is not trivial then it is significantly cheaper to not
  /// even keep the state (see [maintainState]).
  ///
  /// If this property is true, [Opacity] is used instead of [Offstage].
  ///
  /// If this property is false, then [maintainSemantics] and
  /// [maintainInteractivity] must also be false.
  ///
  /// Dynamically changing this value may cause the current state of the
  /// subtree to be lost (and a new instance of the subtree, with new [State]
  /// objects, to be immediately created if [visible] is true).
  ///
  /// Copied from `Visibility`.
  final bool maintainSize;

  /// Whether to maintain the [State] objects of the [child] subtree when it is
  /// not [visible].
  ///
  /// Keeping the state of the subtree is potentially expensive (because it
  /// means all the objects are still in memory; their resources are not
  /// released). It should only be maintained if it cannot be recreated on
  /// demand. One example of when the state would be maintained is if the child
  /// subtree contains a [Navigator], since that widget maintains elaborate
  /// state that cannot be recreated on the fly.
  ///
  /// If this property is true, an [Offstage] widget is used to hide the child
  /// instead of replacing it with [replacement].
  ///
  /// If this property is false, then [maintainAnimation] must also be false.
  ///
  /// Dynamically changing this value may cause the current state of the
  /// subtree to be lost (and a new instance of the subtree, with new [State]
  /// objects, to be immediately created if [visible] is true).
  ///
  /// Copied from `Visibility`.
  final bool maintainState;

  @override
  _FadeAndTranslateState createState() => _FadeAndTranslateState();
}

class _FadeAndTranslateState extends State<FadeAndTranslate>
    with SingleTickerProviderStateMixin {
  /// The current state of the transition.
  bool _visible;

  /// The current offset of the child.
  Offset _translate;

  /// The animation controller used to drive both the
  /// opacity and offset animations.
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Set the initial values.
    _visible = widget.autoStart ? !widget.visible : widget.visible;
    _translate = _visible ? Offset.zero : widget.translate;

    // Build the [AnimationController].
    _animationController = AnimationController(
      duration: widget.duration,
      value: _visible ? 1.0 : 0.0,
      vsync: this,
    );

    if (widget.curve != null) {
      _animationController.drive(CurveTween(curve: widget.curve));
    }

    _animationController.addListener(() {
      _translate = Offset.lerp(
          Offset.zero, widget.translate, _animationController.value);

      if (mounted) setState(() {});
    });

    if (widget.onStart != null || widget.onComplete != null) {
      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget?.onStart();
        } else if (status == AnimationStatus.completed) {
          widget?.onComplete();
        }
      });
    }

    // Toggle the transition if [widget.autoStart] is `true`.
    if (widget.autoStart) {
      final autoStartDelay = widget.autoStartDelay ?? widget.delay;

      if (autoStartDelay != null) {
        Timer(autoStartDelay, () => _toggle());
      } else {
        _toggle();
      }
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(() {});
    _animationController.removeStatusListener((_) {});
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FadeAndTranslate old) {
    if (widget.visible != old.visible) {
      if (widget.delay != null) {
        Timer(widget.delay, () => _toggle());
      } else {
        _toggle();
      }
    }

    super.didUpdateWidget(old);
  }

  void _toggle() {
    if (_visible) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    _visible = widget.visible;

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _animationController.value > 0,
      maintainSize: widget.maintainSize,
      maintainState: widget.maintainState,
      child: AnimatedBuilder(
        animation: _animationController,
        child: widget.child,
        builder: (BuildContext context, Widget child) => Transform.translate(
          offset: _translate,
          transformHitTests: false,
          child: AnimatedOpacity(
            duration: widget.duration,
            opacity: _visible ? 1.0 : 0.0,
            child: child,
          ),
        ),
      ),
    );
  }
}