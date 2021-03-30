import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/settings_model.dart';
import 'package:wevpn/constants.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';
import 'package:wevpn/widgets/input_field/app_input_field.dart';
import 'package:wevpn/widgets/invalid_dialog.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<AppInputFieldState> loginKey = GlobalKey<AppInputFieldState>();
  GlobalKey<AppInputFieldState> passKey = GlobalKey<AppInputFieldState>();
  Widget _rightLabelWidget;

  void _onLoginFocus(hasFocus) {
    var loginState = loginKey.currentState;
    setState(() {
      _rightLabelWidget = !hasFocus && loginState.controller.text.isNotEmpty
          ? buildLoginRightLabel(context, loginState)
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var strings = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: <Widget>[
          AppInputField(
            key: loginKey,
            onFocusChange: _onLoginFocus,
            hintText: strings.loginUsernameHint,
            leftLabel: strings.loginUsernameLabel,
            textInputType: TextInputType.emailAddress,
//            textInputAction: TextInputAction.next,
            validate: validateLogin,
            rightLabelWidget: _rightLabelWidget,
          ),
          AppInputField(
            key: passKey,
            hintText: strings.loginPasswordHint,
            isPassword: true,
            leftLabel: strings.loginPasswordLabel,
            rightLabel: strings.loginForgotPassword,
            rightLabelStyle: Theme.of(context).textTheme.body1.copyWith(
                  color: getCustomColor(context, LINK_COLOR),
                  backgroundColor: Colors.transparent,
                  letterSpacing: -0.45,
                ),
            onTapRightLabel: () {
              launchURL(FORGOT_PSWD_URL);
            },
          ),
          SizedBox(
            height: 21.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              raisedButton(label: strings.loginBtn, onPressed: doLogin),
            ],
          )
        ],
      ),
    );
  }

  bool validateLogin(text) => RegexUtil.isEmail(text);

  doLogin() {
    var loginState = loginKey.currentState;
    if (loginState.controller.text.isEmpty ||
        passKey.currentState.controller.text.isEmpty ||
        !loginState.isValid()) {
      return InvalidDialog(context).show(
          title: S.of(context).invalidLoginDialogTitle,
          description: S.of(context).invalidLoginDialogDescription,
          buttonsContent: buttonsContent());
    } else {
      FocusScope.of(context).unfocus();

      Provider.of<AccountModel>(context, listen: false).active = true;
      Provider.of<AccountModel>(context, listen: false).email =
          loginState.controller.text;
    }
  }

  Column buttonsContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        raisedButton(
            label: S.of(context).invalidLoginDialogTryAgainBtn,
            onPressed: () => Navigator.of(context).pop()),
        SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).invalidLoginDialogOr,
            ),
            formLink(context,
                text: S.of(context).invalidLoginDialogResetPswdBtn,
                link: FORGOT_PSWD_URL,
                onPressed: () => Navigator.of(context).pop()),
          ],
        ),
      ],
    );
  }
}
