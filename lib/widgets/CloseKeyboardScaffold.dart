import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CloseKeyboardScaffold extends StatefulWidget {

  final Widget body;
  final VoidCallback scrollToBottom;

  const CloseKeyboardScaffold({Key key, this.body, this.scrollToBottom}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CloseKeyboardScaffoldState();

}

class _CloseKeyboardScaffoldState extends State<CloseKeyboardScaffold> with WidgetsBindingObserver {
  FocusNode _emptyFocusNode;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible && widget.scrollToBottom != null) {
          _timer.cancel();
          _timer = new Timer(const Duration(milliseconds: 500), () {
            widget.scrollToBottom();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (widget.scrollToBottom != null) {
      if (_timer != null) {
        _timer.cancel();
      }
      var focusScope = FocusScope.of(context);
      if (focusScope.hasFocus && focusScope.focusedChild != _emptyFocusNode) {
        _timer = new Timer(const Duration(milliseconds: 50), () {
          widget.scrollToBottom();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          final focusNode = new FocusNode();
          FocusScope.of(context).requestFocus(focusNode);
          _emptyFocusNode = focusNode;
        },
        child: widget.body,
      ),
    );
  }

}