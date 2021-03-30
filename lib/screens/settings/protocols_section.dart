import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/settings_model.dart';
import 'package:wevpn/generated/i18n.dart';

import 'radio_row.dart';

class ProtocolsSection extends StatelessWidget {

  final EdgeInsets padding;

  const ProtocolsSection({Key key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProtocolModel>(
      builder: (context, model, _) {
        final provider =  Provider.of<SettingsProtocolModel>(context, listen: false);
        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            RadioRow(
              value: ProtocolMode.AUTO,
              groupValue: provider.mode,
              title: S.of(context).settingsProtocolAutomatic,
              subtitle: S.of(context).settingsProtocolAutomaticSubtitle,
              onChanged: (val) => provider.mode = val,
              padding: padding,
            ),
            RadioRow(
              value: ProtocolMode.UDP,
              groupValue: provider.mode,
              title: S.of(context).settingsProtocolUDP,
              subtitle: S.of(context).settingsProtocolUDPSubtitle,
              onChanged: (val) => provider.mode = val,
              padding: padding,
            ),
            RadioRow(
              value: ProtocolMode.TCP,
              groupValue: provider.mode,
              title: S.of(context).settingsProtocolTCP,
              subtitle: S.of(context).settingsProtocolTCPSubtitle,
              onChanged: (val) => provider.mode = val,
              padding: padding,
            )
          ],
        );
      });
  }
}