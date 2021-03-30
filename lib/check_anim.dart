import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wevpn/theme/theme.dart';

import 'theme/styles.dart';

class CheckAnim extends StatefulWidget {
  @override
  State createState() => _CheckAnimState();
}

class _CheckAnimState extends State<CheckAnim> {
  double radius = 26.0;
  double buttonRadius = 31;
  Color buttonColor;
  Color activeButtonColor;

  double stickHeight;

  Duration splashAnimationDuration = Duration(milliseconds: 1300);
  Duration stickAnimationDuration = Duration(milliseconds: 300);

  int spinnerStep = 0;

  @override
  void initState() {
    super.initState();
     radius = 26.0;
     buttonRadius = 31;
     buttonColor = getCustomColor(context, APPBAR_ICON_COLOR_INACTIVE);
     activeButtonColor = getCustomColor(context, APPBAR_BGR_COLOR_ACTIVE);

     stickHeight = 0;
     spinnerStep = 0;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 158,
          height: 158,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(79),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              overflow: Overflow.clip,
              children: [
                Positioned(
                    width: 260,
                    height: 260, //158,
                    child: Center(
                      child: AnimatedContainer(
                        curve: Curves.easeOutBack,
                        width: radius * 2,
                        height: radius * 2,
                        duration: splashAnimationDuration,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(radius)),
                          border: Border.all(
                            color: activeButtonColor,
                            width: 39,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    )
                ),
                Positioned(
                  width: 62,
                  height: 62,
                  child: Center(
                    child: Container(
                      width: buttonRadius * 2,
                      height: buttonRadius * 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
                        color: buttonColor,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 79,
                  width:2,
                  height:20,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                      duration: stickAnimationDuration,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        color: Colors.white,
                      ),
                      height: stickHeight,
                    ),
                    ]
                  ),
                ),

                Positioned(
                  width: 32,
                  height: 32,
                    child: IndexedStack(
                      index: spinnerStep,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: 1.0 * spinnerStep,
                          child: SvgPicture.asset('assets/svgs/power-arc-inactive.svg', color: Colors.white,),
                        ),

                )
                      ]
                    )
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FlatButton(
        child: Text('start'),
        onPressed: () {
          setState(() {
            spinnerStep = 1;

            Future.delayed(Duration(milliseconds: 400), (){
              stickHeight = 16;

              Future.delayed(stickAnimationDuration * 0.8, () {
                setState(() {
                  radius = 111;
                  buttonRadius = 26;
                  buttonColor = activeButtonColor;
                });
              });
            });
          });
        },
      ),
    );
  }
}
