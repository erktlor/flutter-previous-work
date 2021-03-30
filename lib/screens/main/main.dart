import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/connection_model.dart';
import 'package:wevpn/blocks/stats_model.dart';
import 'package:wevpn/screens/main/main_app_bar.dart';
import 'package:wevpn/screens/settings/settings.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';
import 'package:wevpn/we_vpn_icons.dart';
import 'package:wevpn/widgets/location_picker/location_picker.dart';

const double kContentMargin = 40.0;
const double kLandscapeFontSize = 12.0;
const double kLandscapeStatVertPadding = 10.0;
const double kMainCornerRadius = 40.0;

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();
    });

    return OrientationBuilder(builder: (context, orientation) {
      final occupyWidth = orientation == Orientation.portrait
          ? screenWidth(context)
          : screenWidth(context) / 2;

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: MainAppBar(
          context,
          cornerRadius: kContentMargin,
          orientation: orientation,
          onMenuPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          },
          onPowerPressed: () {
            ConnectionModel connectionModel =
                Provider.of<ConnectionModel>(context, listen: false);

            if (connectionModel.canConnect) {
              connectionModel.connect();
            } else if (connectionModel.canDisconnect) {
              connectionModel.disconnect();
            }
          },
        ),
        body: orientation == Orientation.portrait
            ? buildBodyPortrait(context, occupyWidth)
            : buildBodyLandscape(context, occupyWidth),
      );
    });
  }

  Widget buildBodyLandscape(BuildContext context, double occupyWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kContentMargin),
                child: buildLocationPicker(),
              ),
            ],
          ),
        ),
        buildStatus(context, occupyWidth, 150.0, true)
      ],
    );
  }

  Widget buildBodyPortrait(BuildContext context, double occupyWidth) {
    return LayoutBuilder(
      builder: (context, constraints)
    {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kContentMargin),
                  child: buildLocationPicker(),
                ),
              ],
            ),
          ),
          buildStatus(context, occupyWidth,
              min(190.0, max(150, 190 - (384 - constraints.maxHeight))),
              false)
        ],
      );}
    );
  }

  Widget buildLocationPicker() {
    return LocationPicker();
  }

  Widget buildStatus(
      BuildContext context, double width, double height, bool isLandscape) {
    double topPadding =
        isLandscape ? kLandscapeStatVertPadding : kContentMargin - 2;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: getCustomColor(context, APPBAR_BGR_COLOR_INACTIVE),
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(kContentMargin))),
      child: Center(
          child: Padding(
        padding:
            EdgeInsets.fromLTRB(kContentMargin, topPadding, kContentMargin, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: isLandscape
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.start,
          children: <Widget>[
            buildTopStatus(context, isLandscape),
            SizedBox(
              height: 4,
            ),
            separatorHorizontal(context, size: 1),
            buildBottomStatus(context, isLandscape),
          ],
        ),
      )),
    );
  }

  Widget buildTopStatus(BuildContext context, bool isLandscape) {
    return Consumer<ConnectionModel>(
      builder: (context, model, _) => Row(
        children: <Widget>[
          buildDisplayStatus(context, isLandscape,
              label: 'ip', value: model.isConnected ? '192.168.547.15' : '--'),
          buildDisplayStatus(context, isLandscape,
              label: 'vpn ip',
              value: model.isConnected ? '145.581.234.54' : '--'),
        ],
      ),
    );
  }

  Widget buildBottomStatus(BuildContext context, bool isLandscape) {
    return Consumer<StatsModel>(
      builder: (context, model, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildDisplay2Status(context, isLandscape,
              icon: WeVpnIcons.arrow_down, value: model.getDown(), width: 70),
          buildDisplay2Status(context, isLandscape,
              icon: WeVpnIcons.arrow_up, value: model.getUp(), width: 70),
          buildDisplay2Status(
            context,
            isLandscape,
            icon: WeVpnIcons.time_clock,
            value: model.getDuration(),
            width: 57,
          ),
        ],
      ),
    );
  }

  double _displayStatusHeight(isLandscape) {
    double height = 52.0;
    if (isLandscape) {
      height = 40.0;
    }
    return height;
  }

  double _displayStatusIconSize(isLandscape) {
    double height = 16.0;
    if (isLandscape) {
      height = 14.0;
    }
    return height;
  }

  Widget buildDisplayStatus(BuildContext context, isLandscape,
      {String label, value}) {
    TextStyle labelStyle = Theme.of(context)
        .textTheme
        .display3
        .copyWith(fontWeight: FontWeight.normal);
    TextStyle valueStyle = Theme.of(context).textTheme.body1;
    if (isLandscape) {
      labelStyle = labelStyle.copyWith(fontSize: kLandscapeFontSize);
      valueStyle = valueStyle.copyWith(fontSize: kLandscapeFontSize);
    }
    return Expanded(
      child: Container(
        constraints:
            BoxConstraints(minHeight: _displayStatusHeight(isLandscape)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${label.toUpperCase()}:",
              style: labelStyle,
            ),
            SizedBox(
              height: 1.5,
            ),
            Text(
              value,
              style: valueStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDisplay2Status(BuildContext context, bool isLandscape,
      {IconData icon, value, double width}) {
    TextStyle textStyle =
        Theme.of(context).textTheme.body1.copyWith(letterSpacing: -0.6);
    if (isLandscape) {
      textStyle = textStyle.copyWith(fontSize: kLandscapeFontSize);
    }
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: _displayStatusHeight(isLandscape)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: _displayStatusIconSize(isLandscape),
                color: Theme.of(context).textTheme.display3.color,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                value,
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDivider(
    BuildContext context,
  ) {
    return Container(
      height: 2,
      color: Theme.of(context).dividerColor,
    );
  }
}
