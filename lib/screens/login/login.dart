import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/navigation_helper.dart';
import 'package:wevpn/screens/login/login_form.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/widgets/CloseKeyboardScaffold.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final ScrollController _scroll = ScrollController(keepScrollOffset: true);

  void _scrollToBottom() {
    if (mounted) {
      _scroll.animateTo(2000,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CloseKeyboardScaffold(
        scrollToBottom: _scrollToBottom,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: getSystemUiOverlayStyle(context),
          child: LayoutBuilder(
            builder: (context, constraints) =>
                SingleChildScrollView(
                  controller: _scroll,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: constraints.maxHeight),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: <Widget>[
                          SizedBox(height: 145.0,),
                          logoImage(context),
                          SizedBox(height: 50.0,),
                          LoginForm(),
                          SizedBox(
                            height: 23.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 8,),
                              primaryFlatButton(context, S
                                  .of(context)
                                  .loginBuySubscriptionBtn, () {
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pushNamed(
                                    NavigationRoute.StartTrial.path);
                              }, iconPadding: EdgeInsets.only(top: 2)),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ]
                    ),
                  ),
                ),
          ),
        )
    );
  }
}
