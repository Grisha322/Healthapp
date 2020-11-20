import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'dart:async';
import 'dart:math';

abstract class MenuFunction {
  void executeFunction();

  //void returnToMenu() {}
}

class FunctionAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Helthier');
  }
}

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  static AudioCache cache = AudioCache();

  AudioPlayer player;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: RaisedButton(
        elevation: 10,
        onPressed: playHandler,
        child:
            Text(isPlaying ? "Stop" : "Play", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  void playHandler() async {
    if (isPlaying) {
      player.stop();
    } else {
      player = await cache.play('audios/song1.mp3');
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }
}

class ImmediateHelp extends StatefulWidget implements MenuFunction {
  ImmediateHelpState createState() => ImmediateHelpState();
  void executeFunction() {}
}

class ImmediateHelpState extends State<ImmediateHelp>
    with SingleTickerProviderStateMixin {
  int slideNumber;
  int nextSlide;
  Timer _timer;
  AnimationController _controller;
  Animation _fadeAnimation;
  List<Image> slidesForAnimation = new List<Image>();
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        slidesForAnimation[nextSlide],
        FadeTransition(
          opacity: _fadeAnimation,
          child: slidesForAnimation[slideNumber],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Player(),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  void changeBackgroundImage(Timer t) async {
    setState(() {
      slideNumber = nextSlide;
      nextSlide = Random().nextInt(8);
    });
  }

  void initState() {
    super.initState();
    for (int i = 1; i < 9; i++) {
      final Image image = Image.asset(
        'assets/images/Slide$i.jpg',
        fit: BoxFit.cover,
        height: double.infinity,
      );
      slidesForAnimation.add(image);
    }
    slideNumber = 1;
    nextSlide = Random().nextInt(8);
    _controller = new AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _fadeAnimation = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.8,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    _timer =
        new Timer.periodic(const Duration(seconds: 10), changeBackgroundImage);
  }

  @override
  void didChangeDependencies() {
    slidesForAnimation.forEach((image) => precacheImage(image.image, context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
