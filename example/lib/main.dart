import 'package:flutter/material.dart';
import 'package:fade_and_translate/fade_and_translate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fade_and_translate Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'fade_and_translate Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The interval each widget is delayed before transitioning.
  static const Duration _delay = const Duration(milliseconds: 40);

  /// The amount each widget translates during the transition.
  static const Offset _translate = Offset(0.0, -24.0);

  bool _visible = true;

  /// Toggles the visibility of the widgets in the list.
  void _toggle() {
    _visible = !_visible;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        child: Icon(_visible ? Icons.visibility_off : Icons.visibility),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        children: [
          FadeAndTranslate(
            autoStart: true,
            delay: _visible ? _delay * 0 : _delay * 5,
            translate: _translate,
            visible: _visible,
            child: MyWidget(color: Colors.red, label: 'Red'),
          ),
          FadeAndTranslate(
            autoStart: true,
            delay: _visible ? _delay : _delay * 4,
            translate: _translate,
            visible: _visible,
            child: MyWidget(color: Colors.orange, label: 'Orange'),
          ),
          FadeAndTranslate(
            autoStart: true,
            delay: _visible ? _delay * 2 : _delay * 3,
            translate: _translate,
            visible: _visible,
            child: MyWidget(color: Colors.yellow, label: 'Yellow'),
          ),
          FadeAndTranslate(
            autoStart: true,
            delay: _visible ? _delay * 3 : _delay * 2,
            translate: _translate,
            visible: _visible,
            child: MyWidget(color: Colors.green, label: 'Green'),
          ),
          FadeAndTranslate(
            autoStart: true,
            delay: _visible ? _delay * 4 : _delay,
            translate: _translate,
            visible: _visible,
            child: MyWidget(color: Colors.blue, label: 'Blue'),
          ),
          FadeAndTranslate(
            autoStart: true,
            delay: _visible ? _delay * 5 : _delay * 0,
            translate: _translate,
            visible: _visible,
            child: MyWidget(color: Colors.purple, label: 'Purple'),
          ),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({
    @required this.color,
    @required this.label,
  })  : assert(color != null),
        assert(label != null);

  final Color color;

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: color, width: 6.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(2.0, 2.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
