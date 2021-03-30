import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wevpn/screens/main/status.dart';

const double kTooltipHeight = 43.14;

class AppTooltip extends StatefulWidget {
  final Color backgroundColor;
  final Widget text;
  final double height;
  final Status status;

  const AppTooltip(
      {Key key,
      this.backgroundColor = Colors.white,
      this.text,
      this.height = kTooltipHeight,
      this.status,})
      : super(key: key);

  @override
  State createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip> {

  @override
  Widget build(BuildContext context) {

    return Container(
              child: Stack(
                children: <Widget>[
                  SvgPicture.asset('assets/svgs/union.svg',
                      color: widget.backgroundColor,
                      height: widget.height,
                      semanticsLabel: 'TOOLTIP IMAGE'),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.text ?? Text(''),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
    );
  }
}
