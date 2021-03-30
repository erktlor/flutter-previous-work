import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wevpn/screens/main/status.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';

const double _defaultButtonSize = 158.0;
const double _powerIconStrokeWidth = 2.0;

const _internalButtonWidth = 260.0;

class PowerButton extends StatefulWidget {

  final double size;
  final _onPressed;
  final Status status;

  PowerButton(context,
      {Key key,
        this.size = _defaultButtonSize,
        VoidCallback onPressed,
        this.status
      })
      :
        _onPressed = onPressed,
        super(key: key);

  @override
  State createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton> {

  static const Duration zeroDuration = Duration(seconds: 0);
  static const Duration splashDuration = Duration(milliseconds: 1300);
  static const Duration stickDuration = Duration(milliseconds: 200);

  Duration splashAnimationDuration = splashDuration;
  Duration _stickAnimationDuration = stickDuration;

  double splashRadius;
  double buttonRadius;
  double _stickHeight;
  double powerIconWidth;

  static const splashWaveLength = 39.0;

  List<Color> _pwrBtnIconBgrColor;

  // to check if status have changed during build phase
  Status currentStatus;

  bool _showSpinner;

  // stop Animation Timer
  Timer _stopTimer;

  @override
  void initState() {
    super.initState();
    splashRadius = 26.0;
    buttonRadius = 31;
    _stickHeight = 20;
    powerIconWidth = 32.0;
    currentStatus = Status.DISCONNECTED;
    _showSpinner = false;

    //NONE, DISCONNECTED, CONNECTED, CONNECTING, DISCONNECTING

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prepareStatus(currentStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    _pwrBtnIconBgrColor = [
      getCustomColor(context, PWR_BTN_ICON_BGR_COLOR_INACTIVE), // disconnected
      getCustomColor(context, PWR_BTN_ICON_BGR_COLOR_ACTIVE),  // connected
      getCustomColor(context, PWR_BTN_ICON_BGR_COLOR_INACTIVE),  //CONNECTING
      getCustomColor(context, PRIMARY_COLOR),    // DISCONNECTING
    ];

    if (currentStatus != widget.status) {
      currentStatus = widget.status;
      print('status have changed -- ${widget.status.toString()}');

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        prepareStatus(currentStatus);
      });
    }
    return SizedBox(
      width: _defaultButtonSize,
      height: _defaultButtonSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_defaultButtonSize / 2),
        clipBehavior: Clip.hardEdge,
        // put all controls into Stack to allow clipping Positioned widgets
        child: Stack(
            alignment: Alignment.center,
            overflow: Overflow.clip,
            children: [
              // background
              Container(
                color: getCustomColor(context, PWR_BTN_BGR_COLOR_INACTIVE),
              ),

              // circular splash
              Positioned(
                width: _internalButtonWidth,
                height: _internalButtonWidth,
                child: Center(
                  child: AnimatedContainer(
                    curve: Curves.easeOutBack,
                    width: splashRadius * 2,
                    height: splashRadius * 2,
                    duration: splashAnimationDuration,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(splashRadius)),
                      border: Border.all(
                        color: widget.status == Status.CONNECTED ? getCustomColor(context, PWR_BTN_ICON_BGR_COLOR_ACTIVE) : getCustomColor(context, PWR_BTN_BGR_COLOR_INACTIVE),
                        width: splashWaveLength,
                      ),
                      color: getCustomColor(context, PWR_BTN_BGR_COLOR_INACTIVE),
                    ),
                  ),
                ),
              ),

              // central button
              Positioned(
                width: 62,
                height: 62,
                child: Center(
                  child: Container(
                    width: buttonRadius * 2,
                    height: buttonRadius * 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
                      color: _pwrBtnIconBgrColor[_colorIndex(currentStatus)],
                    ),
                  ),
                ),
              ),

              // vertical stick
              Positioned(
                bottom: _defaultButtonSize / 2,
                width: _powerIconStrokeWidth,
                height:20,
                child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        duration: _stickAnimationDuration,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(1)),
                          color: _powerIconColor(context),
                        ),
                        height: _stickHeight,
                      ),
                    ]
                ),
              ),

              // power icon with spinner
              Positioned(
                  width: powerIconWidth,
                  height: powerIconWidth,
                  child: IndexedStack(
                      index: _showSpinner ? 0 : 1,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: _powerIconStrokeWidth,
                          valueColor: AlwaysStoppedAnimation<Color>(_powerIconColor(context)),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: powerIconWidth / 8),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: widget.status == Status.CONNECTED ||  widget.status == Status.DISCONNECTED || widget.status == Status.NONE ? 1 : 0,
                            child: SvgPicture.asset(
                                'assets/svgs/power-arc-inactive.svg',
                                color:_powerIconColor(context)
                            ),
                          ),
                        )
                      ]
                  )
              ),

              // to handle clicks
              GestureDetector(
                onTap: () {
                  if (widget._onPressed != null) {
                    widget._onPressed();
                  }
                },
              ),
            ]
        )
      ),
    );
  }

  void _replaceStopAnimation(Duration duration, VoidCallback callback) {
    if (_stopTimer != null) {
      _stopTimer.cancel();
    }
    _stopTimer = Timer(duration, callback);
  }

  void prepareStatus(Status status) {
    if (status == Status.DISCONNECTED || status == Status.NONE) {
      setState(() {
        _showSpinner = false;
        splashRadius = 26;
        buttonRadius = 31;
        _stickAnimationDuration = stickDuration;
        _stickHeight = 20;
      });
    } else if (status == Status.CONNECTING) {
      setState(() {
        _stickHeight = 0;
        _stickAnimationDuration = stickDuration;
        _showSpinner = false;
        _replaceStopAnimation(stickDuration/* * 0.8*/, ()
        {
          if (status == Status.CONNECTING) {
            setState(() {
              _stickHeight = 0;
              _stickAnimationDuration = zeroDuration;
              _showSpinner =
              true; //== Status.CONNECTING ||  widget.status == Status.DISCONNECTING ? 0 : 1
              splashRadius = 26;
              buttonRadius = 31;
            });
          }
        });
      });
    } else if (status == Status.DISCONNECTING) {
      setState(() {
        _stickHeight = 0;
        _stickAnimationDuration = stickDuration;

        _showSpinner = false;
        _replaceStopAnimation(stickDuration/* * 0.8*/, ()
        {
          if (status == Status.DISCONNECTING) {
            setState(() {
              _showSpinner = true;
              splashRadius = 26;
              buttonRadius = 31;
              splashAnimationDuration = zeroDuration;
            });
          }
        });
      });
    } else if (status == Status.CONNECTED) {
      setState(() {
        _showSpinner = false;
        _stickHeight = 0;
        _stickAnimationDuration = zeroDuration;

        _replaceStopAnimation(stickDuration, () {
        if (status == Status.CONNECTED) {
          setState(() {
            _showSpinner = false;
            _stickHeight = 20;
            _stickAnimationDuration = stickDuration;

            _replaceStopAnimation(stickDuration * 0.8, () {
              if (status == Status.CONNECTED) {
                setState(() {
                  _showSpinner = false;
                  splashRadius = 111;
                  buttonRadius = 26;
                  splashAnimationDuration = splashDuration;
                });
              }
            });
          });
        }
      });
      });
    }

  }

  int _colorIndex(Status status) {

    // DISCONNECTED, CONNECTED, CONNECTING, DISCONNECTING
    if (status == Status.DISCONNECTED ||status == Status.NONE) {
      return 0;
    } else if (status == Status.CONNECTED) {
      return 1;
    } else if (status == Status.CONNECTING) {
      return 2;
    } else {
      return 3;
    }

  }

  Color _powerIconColor(BuildContext context) {
    return getCustomColor(
        context,
        widget.status == Status.CONNECTED || widget.status == Status.DISCONNECTING
            ? PWR_BTN_ICON_COLOR_ACTIVE
            : PWR_BTN_ICON_COLOR_INACTIVE);

  }
}
