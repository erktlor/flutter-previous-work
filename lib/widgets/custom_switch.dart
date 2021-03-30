import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class CustomSwitch extends StatelessWidget {
  final bool checked;

  CustomSwitch({this.checked});

  @override
  Widget build(BuildContext context) {
    var tween = MultiTrackTween([
      Track("paddingLeft")
          .add(Duration(milliseconds: 100), Tween(begin: 0.0, end: 20.0)),
      Track("color").add(Duration(milliseconds: 100),
          ColorTween(begin: Theme.of(context).disabledColor, end: Theme.of(context).primaryColor)),
      Track("text")
          .add(Duration(milliseconds: 100), ConstantTween(""))
          .add(Duration(milliseconds: 100), ConstantTween("")),
      Track("rotation")
          .add(Duration(milliseconds: 100), Tween(begin: -2 * pi, end: 0.0))
    ]);

    return ControlledAnimation(
      playback: checked ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
      startPosition: checked ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(context, animation) {
    return Container(
      decoration: _innerBoxDecoration(animation["color"]),
      width: 44,
      height: 24,
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Positioned(
              child: Padding(
                padding: EdgeInsets.only(left: animation["paddingLeft"]),
                child: Transform.rotate(
                  angle: animation["rotation"],
                  child: Container(
                    decoration: _innerBoxDecoration(Colors.white),
                    width: 16,
                    child:
                    Center(child: Text(animation["text"], style: labelStyle)),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: color
  );

  static final labelStyle = TextStyle(
      height: 1.2,
      fontWeight: FontWeight.bold,
      fontSize: 9,
      color: Colors.white);
}