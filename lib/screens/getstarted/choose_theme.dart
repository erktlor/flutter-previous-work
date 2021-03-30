import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/theme_changer.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/screens/settings/radio_row.dart';

import '../../theme/styles.dart';
import '../../theme/theme.dart';

class ChooseThemeStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChooseThemeStepState();
}

class _ChooseThemeStepState extends State<ChooseThemeStep> {
  ThemeData _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme =
        Provider.of<ThemeChanger>(context, listen: false).getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final mainPadding = orientation == Orientation.portrait ? 60.0 : 20.0;
          final bottomMainPadding = orientation == Orientation.portrait ? 43.0 : 20.0;
          return Container(
            color: Theme.of(context).dialogTheme.backgroundColor,
            padding: EdgeInsets.symmetric(vertical: 17, horizontal: 20).copyWith(right: 21),
            child: SafeArea(
              child: Container(
              padding: EdgeInsets.only(top: mainPadding, bottom: bottomMainPadding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.background),
              child: orientation == Orientation.portrait ? _buildPortrait() : _buildLandscape(),
            )),
          );
        },
      ),
    );
  }

  Widget _nonTogglePadding(Widget child) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 33, bottom: 12, top:0),
      child: child,
    );
  }

  Widget _outlineTheme(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: getCustomColor(context, SETTINGS_DELIMITER_COLOR),
      ),
      padding: EdgeInsets.all(1),
      child: child,
    );
  }

  Widget _buildPortrait() {
    EdgeInsets radioPadding = EdgeInsets.symmetric(vertical: 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: SizedBox(
            height: 44.5,
            child: SvgPicture.asset(
              'assets/svgs/bucket.svg',
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 13, left: 2, right:0),
            child: Text(
              S.of(context).themeChooseTheme,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.normal),
            )),
        SizedBox(
          height: 26,
        ),
        Padding(
          padding: EdgeInsets.only(left: 28, bottom: 6.5),
          child: RadioRow(
            value: lightTheme,
            groupValue: _selectedTheme,
            title: S.of(context).settingsGeneralAppearanceLight,
            onChanged: (val) => setState(() => _selectedTheme = val),
            padding: radioPadding,
            toggleHeight: 32,
          ),
        ),
        _selectedTheme == lightTheme
            ? Expanded(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: EdgeInsets.only(top: 2.5),
              child:_nonTogglePadding(
                _outlineTheme(Image.asset(
              'assets/images/theme-light.png',
              fit: BoxFit.fitHeight,
            ))),
          ),
        ))
            : Container(
          height: 0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 28,),
          child: RadioRow(
            value: darkTheme,
            groupValue: _selectedTheme,
            title: S.of(context).settingsGeneralAppearanceDark,
            onChanged: (val) => setState(() => _selectedTheme = val),
            padding: radioPadding,
            toggleHeight: 32,
          ),
        ),

        _selectedTheme == darkTheme
            ? Expanded(
          child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: EdgeInsets.only(top:8),
                  child:_nonTogglePadding(
                  _outlineTheme(Image.asset(
                    'assets/images/theme-dark.png',
                    fit: BoxFit.fitHeight,
                  )
                  ))
              )
          ),
        )
            : Container(
          height: 8,
        ),
        SizedBox(
          height: 25,
        ),
        Padding(padding: EdgeInsets.only(left: 43, right: 43),
            child:raisedButton(
            label: S.of(context).themeContinue, onPressed: _applyTheme)),
      ],
    );
  }

  Widget _buildLandscape() {
    EdgeInsets radioPadding = EdgeInsets.symmetric(vertical: 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _nonTogglePadding(SizedBox(
              width: 56,
              height: 58,
              child: SvgPicture.asset(
                'assets/svgs/bucket.svg',
              ),
            )),
            Padding(
                padding: EdgeInsets.only(top: 14, left: 12),
                child: Text(
                  S.of(context).themeChooseTheme,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.normal),
                )),

          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  RadioRow(
                    value: lightTheme,
                    groupValue: _selectedTheme,
                    title: S.of(context).settingsGeneralAppearanceLight,
                    onChanged: (val) => setState(() => _selectedTheme = val),
                    padding: radioPadding,
                    toggleHeight: 32,
                  ),
                  RadioRow(
                    value: darkTheme,
                    groupValue: _selectedTheme,
                    title: S.of(context).settingsGeneralAppearanceDark,
                    onChanged: (val) => setState(() => _selectedTheme = val),
                    padding: radioPadding,
                    toggleHeight: 32,
                  ),
                ],
              ),
              SizedBox(width: 50,),
              Column(
                children: <Widget>[
                  _selectedTheme == lightTheme
                      ? Expanded(
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: _nonTogglePadding(
                          _outlineTheme(Image.asset(
                        'assets/images/theme-light.png',
                        fit: BoxFit.fitHeight,
                      ))),
                    ))

                      : Container(
                    height: 0,
                  ),

                _selectedTheme == darkTheme
                    ? Expanded(
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: _nonTogglePadding(
                          _outlineTheme(Image.asset(
                            'assets/images/theme-dark.png',
                            fit: BoxFit.fitHeight,
                          )
                          )
                      )
                  ),
                )
                    : Container(
                  height: 0,
                ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _nonTogglePadding(raisedButton(
            label: S.of(context).themeContinue, onPressed: _applyTheme)),
      ],
    );
  }

  void _applyTheme() {
    FocusScope.of(context).unfocus();
    Provider.of<ThemeChanger>(context).setTheme(_selectedTheme);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
