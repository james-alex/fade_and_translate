# fade_and_translate

[![pub package](https://img.shields.io/pub/v/fade_and_translate.svg)](https://pub.dartlang.org/packages/fade_and_translate)

A widget that toggles the visibility of its child by simultaneously
fading the child in or out while translating its positional offset.

# Usage

```dart
import 'package:fade_and_translate/fade_and_translate.dart';
```

fade_and_translate consists of a single widget, [FadeAndTranslate], which has
a binary state of being visible or hidden that's controlled by the parent.

[FadeAndTranslate] has two required parameters: [child] and [translate],
which specifies the offset to translate the child to and from.

### Visibility & Duration

[FadeAndTranslate]'s [child] is visible by default. The transition can be
triggered by changing the [visible] parameter.

The duration of the transition can be specified by the [duration] parameter,
which defaults to `Duration(milliseconds: 120)`.

```dart
/// Builds a widget that's hidden and will transition
/// in when [visible] is set to `true`.
FadeAndTranslate(
  visible: false,
  translate: Offset(0.0, 20.0),
  child: MyWidget(),
);

/// Builds a widget that's visible by default and will transition to
/// being hidden when [visible] is set to `false`. The transition will
/// take 240ms to complete.
FadeAndTranslate(
  visible: true,
  translate: Offset(0.0, 20.0),
  duration: Duration(milliseconds: 240),
  child: MyWidget(),
);
```

### Auto-start

[FadeAndTranslate] has a parameter, [autoStart], that will start the transition
automatically once the widget has been built. If [autoStart] is `true`, the widget
will start in the state opposite of [visible] and transition to the state defined
by [visible].

```dart
/// Builds a widget that starts out hidden and transitions to being
/// visible as soon as it's built.
FadeAndTranslate(
  autoStart: true,
  translate: Offset(0.0, 20.0),
  child: MyWidget(),
);
```

### Delays

Both the transition toggled by [visible] and one triggered by [autoStart] can
be set to start at a delay from when they've been triggered.

The [delay] parameter is used to specify the [Duration] which to delay the
transition togged by [visible], and [autoStartDelay] can be set to delay the
[autoStart]'s transition. If [delay] is set and [autoStartDelay] is not,
[autoStartDelay] will inherit [delay]'s [Duration].

```dart
/// Changing this value will toggle the transitions of all the below widgets.
var _visible = true;

/// Builds a widget that will start its transition 120ms
/// after [_visible] has been toggled.
FadeAndTranslate(
  visible: _visible,
  delay: Duration(milliseconds: 120),
  translate: Offset(0.0, 20.0),
  child: MyWidget(),
);

/// Builds a widget that will transition to the state of [_visible] 120ms
/// after its been built, and will immediately transition when [_visible]
/// is toggled.
FadeAndTranslate(
  visible: _visible,
  autoStartDelay: Duration(milliseconds: 120),
  autoStart: true,
  translate: Offset(0.0, 20.0),
  child: MyWidget(),
);

/// Builds a widget that will immediately transition to the state of [_visible]
/// once it's been built, and will transition 120ms after [_visible] has been
/// toggled.
FadeAndTranslate(
  visible: _visible,
  delay: Duration(milliseconds: 120),
  autoStartDelay: Duration.zero,
  autoStart: true,
  translate: Offset(0.0, 20.0),
  child: MyWidget(),
);
```

### Animation Curves

An animation curve can be set with the [curve] parameter. The curve will be
applied to both the opacity and the offset animations.

Any of the curves defined in Flutter's [Curves] utility class can be used,
or you can build a curve yourself.

```dart
/// Builds a widget with a curved tween.
FadeAndTranslate(
  visible: _visible,
  translate: Offset(0.0, 20.0),
  curve: Curves.easeIn,
  child: MyWidget(),
);
```

### Callbacks

[FadeAndTranslate] has two callbacks, [onStart] and [onComplete], which will
be called when the state of the animation reaches [AnimationStatus.dismissed]
and [AnimationStatus.completed] respectively.

```dart
/// Builds a widget with callbacks that note the state of the transition.
FadeAndTranslate(
  visible: _visible,
  translate: Offset(0.0, 20.0),
  onStart: () => print('Starting transition.'),
  onComplete: () => print('Transition has finished.'),
  child: MyWidget(),
);
```
