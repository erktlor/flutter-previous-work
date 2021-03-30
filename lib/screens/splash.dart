import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wevpn/theme/styles.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController rotationController;


  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    rotationController.forward();
    rotationController.addListener(() {
      setState(() {
        if (rotationController.status == AnimationStatus.completed) {
          rotationController.repeat();
        }
      });
    });
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyle(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logoImage(context),
              SizedBox(
                height: 25,
              ),
              RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(
                      rotationController),
                  child:
                  Container(
                      height: 64.0,
                      width: 64.0,
                      child: Image.asset(
                          'assets/images/preloader-${ isLightTheme(context)
                              ? 'light'
                              : 'dark'}.png')
                  )
              )
            ],
          ),
        ),
      )
    );
  }
}
