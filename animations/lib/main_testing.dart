// this file was created to test how transition and animation work in Flutter.
// Please go to "main.dart" to read the real code.

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Intro',
      debugShowCheckedModeBanner: false,
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation; 

  @override
  void initState(){
    super.initState();

    controller = AnimationController( 
      vsync: this,
      duration: Duration(milliseconds: 2000)
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controller.reverse();
      } else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });

    controller.forward();

  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GabrielTransition(
      child: LogoWidget(),
      animation: animation,
    );
  }
}

class AnimatedLogo extends AnimatedWidget {

  AnimatedLogo(Animation<double> animation) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Center(
      child: Container(
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
  
}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

class GabrielTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;

  GabrielTransition({this.child, this.animation});

  final sizeTween = Tween<double>(begin: 0, end: 300);
  final opacityyTween = Tween<double>(begin: 0.1, end: 1);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child){
          return Opacity(
            opacity: opacityyTween.evaluate(animation).clamp(0.0, 1.0),
            child: Container(
              height: sizeTween.evaluate(animation).clamp(0.0, 400.0),
              width: sizeTween.evaluate(animation).clamp(0.0, 400.0),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}