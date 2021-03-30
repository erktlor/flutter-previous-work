import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/theme_changer.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/theme/theme.dart';

import 'radio_row.dart';

class ThemeSection extends StatelessWidget {

  final EdgeInsets padding;
  final ValueChanged<ThemeData> onChanged;

  const ThemeSection({Key key, this.padding, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, model, _) => ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            RadioRow(
              value: lightTheme,
              groupValue: model.getTheme(),
              title: S.of(context).settingsGeneralAppearanceLight,
              onChanged: (val) => _onSelected(Theme.of(context).brightness, val),
              padding: padding,
              toggleHeight: 32,
            ),
            SizedBox(height: 1,),
            RadioRow(
              value: darkTheme,
              groupValue: model.getTheme(),
              title: S.of(context).settingsGeneralAppearanceDark,
              onChanged: (val) => _onSelected(Theme.of(context).brightness, val),
              padding: padding,
              toggleHeight: 32,
            ),
          ]),
    );
  }

  _onSelected(Brightness originalBrightness, ThemeData val) async {
    if (val.brightness != originalBrightness)
    if (onChanged != null) {
      onChanged(val);
    }
  }
}
