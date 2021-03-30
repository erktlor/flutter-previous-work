import 'package:flutter/material.dart';
import 'package:wevpn/we_vpn_icons.dart';

class InvalidDialog {
  final BuildContext context;

  InvalidDialog(this.context);

  Future<bool> show(
      {bool isOverlayTapDismiss = false,
      Duration animationDuration = const Duration(milliseconds: 200),
      String title,
      String description,
      Widget buttonsContent}) async {
    Color overlayColor = Theme.of(this.context).dialogTheme.backgroundColor;
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation, _) {
          return _buildDialog(title, description, buttonsContent);
        },
        barrierDismissible: isOverlayTapDismiss,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: overlayColor,
        transitionDuration: animationDuration,
        transitionBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) =>
            _showAnimation(animation, child));
  }

  _showAnimation(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  Widget _buildDialog(String title, String description,
      [Widget buttonsContent]) {
    var theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
            backgroundColor: theme.dialogBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 10,
            titlePadding: EdgeInsets.all(0.0),
            title: _buildTitle(
                title: title, desc: description, buttons: buttonsContent),
            contentPadding: EdgeInsets.fromLTRB(40, 20, 40, 40),
            content: buttonsContent),
      ),
    );
  }

  Container _buildTitle({@required title, desc, content, buttons}) {
    var theme = Theme.of(context);
    return Container(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(40, 40, 40, buttons == null ? 40 : 0),
            child: Column(
              children: <Widget>[
                Icon(
                  WeVpnIcons.warning,
                  size: 46.0,
                  color: theme.primaryColor,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  title,
                  style: theme.dialogTheme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: desc == null ? 5 : 19,
                ),
                desc == null
                    ? Container()
                    : Text(
                        desc,
                        style: theme.dialogTheme.contentTextStyle.copyWith(height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                content == null ? Container() : content,
              ],
            ),
          )
        ],
      ),
    ));
  }
}
