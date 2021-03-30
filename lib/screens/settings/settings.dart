import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/settings_model.dart';
import 'package:wevpn/blocks/theme_changer.dart';
import 'package:wevpn/blocks/version_model.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/screens/settings/check_row.dart';
import 'package:wevpn/screens/settings/protocols_section.dart';
import 'package:intl/intl.dart';

import '../../theme/styles.dart';
import '../../theme/theme.dart';
import 'switch_row.dart';
import 'theme_section.dart';

class SettingsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _showList;
  bool _changingTheme;
  Color _maskColor;
  Duration _changingThemeDuration;

  bool _lockChanges;

  @override
  void initState() {
    super.initState();
    _showList = true;
    _changingTheme = false;
    _maskColor = Provider.of<ThemeChanger>(context, listen: false).getTheme().scaffoldBackgroundColor;
    _changingThemeDuration = Duration(seconds: 0);
    _lockChanges = false;
  }

  @override
  Widget build(BuildContext context) {

    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    Color dividerColor = themeChanger.getAppThemeColors().getColor(SETTINGS_DELIMITER_COLOR);

    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 28);
    EdgeInsets textPadding = EdgeInsets.symmetric(horizontal: 40);

    TextStyle labelTextStyle = Theme.of(context).textTheme.caption.copyWith(fontSize: 12);
    TextStyle valueTextStyle = Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.w600);

    return AnimatedCrossFade(
        duration: _changingThemeDuration,
        crossFadeState: _changingTheme ? CrossFadeState.showSecond : CrossFadeState.showFirst,

        firstChild:_showList
        ? _buildList(context, dividerColor, padding, textPadding, labelTextStyle, valueTextStyle)
        : Container(),
      secondChild: Container(
        color: _maskColor,
        child: Center(),
      ),
    );
  }

  Scaffold _buildList(BuildContext context, Color dividerColor, EdgeInsets padding, EdgeInsets textPadding, TextStyle labelTextStyle, TextStyle valueTextStyle) {
    return Scaffold(
    appBar: settingsAppBar(context, S.of(context).settingsTitle),
    body: ListView(
      children: <Widget>[
        _headerRow(context, 'assets/svgs/s-general.svg', S.of(context).settingsGeneral),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        Container(
          padding: EdgeInsets.only(top: 36, bottom: 36),
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Consumer<SettingsConnectionModel>(
                builder: (context, model, _) => CheckRow(
                  title: S.of(context).settingsGeneralLaunchOnStart,
                  padding: padding,
                  toggleHeight: 32,
                  value: model.launchOnStartup,
                  onChanged: (val) => model.launchOnStartup = val,
                ),
              ),
              SizedBox(height: 8,),
              Consumer<SettingsConnectionModel>(
                builder: (context, model, _) => CheckRow(
                  title: S.of(context).settingsGeneralConnectOnLaunch,
                  padding: padding,
                  toggleHeight: 32,
                  value: model.connectOnLaunch,
                  onChanged: (val) => model.connectOnLaunch = val,
                ),
              ),
              Padding(
                padding: textPadding.copyWith(top: 21, bottom: 3,),
                child: Text(S.of(context).settingsGeneralAppearance, style: labelTextStyle,)
              ),
              ThemeSection(padding: padding, onChanged: _themeChanged),
            ],
          ),
        ),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        _headerRow(context, 'assets/svgs/s-protocol.svg', S.of(context).settingsProtocol),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        Container(
          padding: EdgeInsets.only(top: 28, bottom: 35),
          color: Theme.of(context).backgroundColor,
          child: ProtocolsSection(padding: padding),
        ),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        _headerRow(context, 'assets/svgs/s-privacy.svg', S.of(context).settingsPrivacy),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        Container(
          padding: EdgeInsets.only(top: 34, bottom: 29),
          color: Theme.of(context).backgroundColor,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Consumer<SettingsPrivacyModel>(
                  builder: (context, model, _) => SwitchRow(
                    title: '${S.of(context).settingsPrivacyVPNKill} (${model.vpnKill ? 'On' : 'Off'})',
                    subtitle: S.of(context).settingsPrivacyVPNKillSubtitle,
                    padding: textPadding,
                    toggleHeight: 32,
                    value: model.vpnKill,
                    onChanged: (val) => model.vpnKill = val,
                    bold: true,
                  ),
                ),
                Consumer<SettingsPrivacyModel>(
                  builder: (context, model, _) => CheckRow(
                    title: S.of(context).settingsPrivacyAutoReconnect,
                    subtitle: S.of(context).settingsPrivacyAutoReconnectSubtitle,
                    padding: padding,
                    toggleHeight: 32,
                    value: model.autoReconnect,
                    onChanged: (val) => model.autoReconnect = val,
                    bold: true,
                  ),
                ),
              ]
          )
        ),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        _headerRow(context, 'assets/svgs/s-account.svg', S.of(context).settingsAccount),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        _accountSection(context, textPadding, labelTextStyle, valueTextStyle),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        _headerRow(context, 'assets/svgs/s-help.svg', S.of(context).settingsHelp),
        Divider(color: dividerColor, indent: 0, endIndent: 0,),
        _helpSection(context, padding, textPadding, labelTextStyle),
      ],
    ),
  );
  }

  Widget _headerRow(BuildContext context, String assetName, String title) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.display3;
    return Container(
      height: 55.5,
      color: theme.appBarTheme.color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 33,),
          SizedBox(width: 32, height: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: SvgPicture.asset(assetName, color: textStyle.color, width: 16, height: 16,),
              )
              ]
            ),
          ),
          Text(title, style: textStyle.copyWith(fontSize: 12.0),)
        ],
      ),
    );
  }

  Widget _helpSection(BuildContext context, EdgeInsets padding, EdgeInsets textPadding, TextStyle labelTextStyle) {
    return Container(
        padding: EdgeInsets.only(top: 34, bottom: 40),
        color: Theme.of(context).backgroundColor,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: textPadding,
                child: Text(S.of(context).settingsHelpVersion, style: labelTextStyle,),
              ),
              Padding(
                padding: textPadding.copyWith(top: 4, bottom: 18),
                child: Consumer<VersionModel>(
                  builder: (context, version, _) => Text('v${version.projectVersion} (Build ${version.projectCode.padLeft(5, '0')})'),
                ),
              ),
              Consumer<SettingsAutoUpdateModel>(
                builder: (context, model, _) => CheckRow(
                  title: S.of(context).settingsHelpAutoUpdate,
                  padding: padding,
                  toggleHeight: 32,
                  value: model.enabled,
                  onChanged: (val) => model.enabled = val,
                ),
              ),
              Padding(
                padding: textPadding.copyWith(top: 20),
                child: raisedButton(
                    label: S.of(context).settingsHelContactUs,
                    onPressed: () {
                      launchURL(S.of(context).settingsHelContactUsURL);
                    }
                ),
              ),
            ]
        )
    );
  }

  Widget _accountSection(BuildContext context, EdgeInsets textPadding, TextStyle labelTextStyle, TextStyle valueTextStyle) {
    return Container(
        padding: EdgeInsets.only(top: 36, bottom: 24),
        color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: textPadding,
              child: Text(S.of(context).settingsAccountEmail, style: labelTextStyle,),
            ),
            Padding(
              padding: textPadding.copyWith(top: 4, bottom: 18),
              child: Consumer<AccountModel>(
                builder: (context, model, _) => Text(model.email ?? '', style: valueTextStyle),
              ),
            ),
            Padding(
              padding: textPadding,
              child: Text(S.of(context).settingsAccountStatus, style: labelTextStyle,),
            ),
            Padding(
              padding: textPadding.copyWith(top: 4, bottom: 18),
              child: Consumer<AccountModel>(
                builder: (context, model, _) {
                  if (true /*model.active*/) {
                    return Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/svgs/check-small.svg',width: 8, color: getCustomColor(context, APPBAR_BGR_COLOR_ACTIVE),),
                        SizedBox(width: 7,),
                        Text(S.of(context).settingsAccountStatusActive, style: valueTextStyle.copyWith(color: getCustomColor(context, APPBAR_BGR_COLOR_ACTIVE))),
                        SizedBox(width: 5,),
                        Text('(${model.plan.otherName})', style: valueTextStyle),
                      ],
                    );
                  }
                  return Text(S.of(context).settingsAccountStatusInactive);
                  }
                ),
            ),
            Padding(
              padding: textPadding,
              child: Text(S.of(context).settingsAccountRenews, style: labelTextStyle,),
            ),
            Padding(
              padding: textPadding.copyWith(top: 4, bottom: 4),
              child: Consumer<AccountModel>(
                  builder: (context, model, _) {
                    final days = model.renewDate.difference(DateTime.now()).inDays.toString();
                    final dateFormat = DateFormat('MMMM d, yyyy');
                    return Text('${dateFormat.format(model.renewDate)} ($days ${S.of(context).settingsAccountRenewsDaysLeft})', style: valueTextStyle,);
                  }
              ),
            ),
            Padding(
              padding: textPadding,
              child:
                linkButton(
                  context,
                  S.of(context).settingsAccountSignout,
                  onPressed: () {
                    Provider.of<AccountModel>(context, listen: false).signOut();
                    Navigator.of(context).pop();
                  }
                ),
            ),

          ]
        ),
    );
  }

  void _themeChanged(ThemeData value) {
    if (!_lockChanges) {
      _lockChanges = true;

      ThemeChanger themeChanger = Provider.of<ThemeChanger>(
          context, listen: false);

      setState(() {
        _changingTheme = true;
        _changingThemeDuration = Duration(milliseconds: 200);

        Future.delayed(Duration(milliseconds: 250), () {
          _showList = false;
          themeChanger.setTheme(value);
          Future.delayed(Duration(milliseconds: 250), () {
            setState(() {
              _showList = true;
              _changingThemeDuration = Duration(milliseconds: 1500);
              _changingTheme = false;
            });
            _maskColor = Theme
                .of(context)
                .scaffoldBackgroundColor;
              _lockChanges = false;
          });
        });
      });
    }
  }
}
