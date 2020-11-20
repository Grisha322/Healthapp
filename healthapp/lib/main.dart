import 'package:flutter/material.dart';
import 'function.dart';

void main() {
  runApp(myApp);
}

StatefulWidget myApp = new MaterialApp(
  home: TapScreen(),
);

class TapScreen extends StatefulWidget {
  TapScreen({Key key}) : super(key: key);

  @override
  TapScreenState createState() => TapScreenState();
}

class TapScreenState extends State<TapScreen> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _active ? Text('Healthier') : FunctionAppBar(),
      ),
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.translucent,
        child: SizedBox.expand(
          child: Container(
            alignment: Alignment.center,
            child: (_active
                ? Text(
                    'Menu',
                    style: TextStyle(fontSize: 32.0, color: Colors.black),
                  )
                : ImmediateHelp()),
          ),
        ),
      ),
    );
  }
}
