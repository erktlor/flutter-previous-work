import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/settings_model.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/screens/getstarted/signup_form.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/widgets/CloseKeyboardScaffold.dart';

class GetStartedSignupStep extends StatefulWidget {
  @override
  State createState() => _GetStartedSignupStepState();
}

class _GetStartedSignupStepState extends State<GetStartedSignupStep> {
  final ScrollController _scroll = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AccountModel>(context).introPassed(needLogin: true);
    });
  }

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
        body: LayoutBuilder(
            builder: (context, viewportConstraints) => SingleChildScrollView(
                controller: _scroll,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).colorScheme.surface,
                          padding: EdgeInsets.fromLTRB(40, 60, 40, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              logoImage(context, width: 91.2, height: 29.23),
                              Padding(
                                padding: EdgeInsets.only(right: 1),
                                child: closeIconButton(() {
                                  Navigator.of(context).pop();
                                }),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).colorScheme.surface,
                          padding:
                              EdgeInsets.only(left: 40, top: 74, bottom: 12),
                          child: Text(
                            S.of(context).getStartedTitle,
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          padding: EdgeInsets.only(left: 40, bottom: 50),
                          margin: EdgeInsets.only(bottom: 31),
                          child: Text(
                            S.of(context).getStartedDescription,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                        Flexible(child: SignupForm()),
                      ],
                    )))));
  }
}
