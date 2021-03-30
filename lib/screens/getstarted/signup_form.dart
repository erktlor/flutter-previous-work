import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/settings_model.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/widgets/input_field/app_input_field.dart';
import 'package:wevpn/widgets/invalid_dialog.dart';

import '../../navigation_helper.dart';
import '../../theme/styles.dart';

class SignupForm extends StatefulWidget {

  @override
  State createState() => _SignupFormState();

}

class _SignupFormState extends State<SignupForm> {
  GlobalKey<AppInputFieldState> loginKey = GlobalKey<AppInputFieldState>();
  GlobalKey<AppInputFieldState> passKey = GlobalKey<AppInputFieldState>();
  Widget _rightLabelWidget;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return bottomBar([
      AppInputField(
        key: loginKey,
        onFocusChange: _onLoginFocus,
        hintText: strings.loginUsernameHint,
        leftLabel: strings.loginUsernameLabel,
        textInputType: TextInputType.emailAddress,
//            textInputAction: TextInputAction.next,
        validate: (value) => RegexUtil.isEmail(value),
        rightLabelWidget: _rightLabelWidget,
      ),
      SizedBox(
        height: 0,
      ),
      AppInputField(
        key: passKey,
        hintText: strings.loginPasswordHint,
        isPassword: true,
        leftLabel: strings.loginPasswordLabel,
        rightLabelStyle: Theme.of(context).textTheme.body1.copyWith(
          color: Theme.of(context).highlightColor,
          backgroundColor: Colors.transparent,
          letterSpacing: -0.45,
        ),
      ),
      SizedBox(
        height: 21.0,
      ),
      raisedButton(
        label: S.of(context).getStartedButtonLabel,
        onPressed: _doSignup,
      ),
      SizedBox(
        height: 9.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 6.0,),
          primaryFlatButtonExternal(context, () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
              title: Row(
                children: <Widget>[
                  Text(
                    S.of(context).onboardingExistingUser,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  SizedBox(
                    width: 9.0,
                  ),
                  Text(
                    S.of(context).onboardingLogin,
                  ),
                ],
              )),
        ],
      ),
      htmlWithLinks(context, S.of(context).getStartedTos),
    ]);
  }

  void _onLoginFocus(hasFocus) {
    var loginState = loginKey.currentState;
    setState(() {
      _rightLabelWidget = !hasFocus && loginState.controller.text.isNotEmpty
          ? buildLoginRightLabel(context, loginState)
          : null;
    });
  }

  void _doSignup() {
    if (loginKey.currentState.controller.text.isEmpty || !loginKey.currentState.isValid() || passKey.currentState.controller.text.isEmpty) {
      InvalidDialog(context).show(
        title: S.of(context).getStartedInvalidDialogTitle,
        description: S.of(context).getStartedInvalidDialogDescription,
        buttonsContent: buttonsContent()
      );
    } else {
      FocusScope.of(context).unfocus();

      Provider.of<AccountModel>(context, listen: false).email = loginKey.currentState.controller.text;
      Provider.of<AccountModel>(context, listen: false).active = true;

      Navigator.of(context).pushReplacementNamed(NavigationRoute.SelectPlan.path);
    }
  }

  Column buttonsContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        raisedButton(
            label: S.of(context).getStartedInvalidDialogTryAgainBtn,
            onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}