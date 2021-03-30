import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/connection_model.dart';
import 'package:wevpn/blocks/theme_changer.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/screens/main/status.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';
import 'package:wevpn/widgets/power_button.dart';
import 'package:wevpn/widgets/tooltip.dart';

const double kAppBarHeight = 257.0;
const double kPowerBtnSize = 158.0;
const double kMargin = 10.0;
const double kTooltipHeight = 43.14;

// Landscape
const double kAppBarHeightLandscape = 160;

const Duration _connectionAnimationDelay = Duration(milliseconds: 600);
const Duration _tooltipAnimationDuration = Duration(milliseconds: 300);

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final _statusBarHeight;
  final _screenWidth;
  final List<Color> _appbarBgrColor;
  final List<Color> _appbarIconColor;
  final VoidCallback onPowerPressed;
  final VoidCallback onMenuPressed;
  final cornerRadius;
  final Orientation orientation;

  MainAppBar(
    context, {
    Key key,
    this.onPowerPressed,
    this.onMenuPressed,
    this.cornerRadius,
    this.orientation,
  })  : _statusBarHeight = statusBarHeight(context),
        _screenWidth = screenWidth(context),
        _appbarBgrColor = [
          getCustomColor(context, APPBAR_BGR_COLOR_INACTIVE),
          getCustomColor(context, APPBAR_BGR_COLOR_ACTIVE),
        ],
        _appbarIconColor = [
          getCustomColor(context, APPBAR_ICON_COLOR_INACTIVE),
          getCustomColor(context, APPBAR_ICON_COLOR_ACTIVE),
        ],
        super(key: key);

  @override
  State createState() => _MainAppBarState();

  double get appBarHeight => orientation == Orientation.portrait
      ? kAppBarHeight
      : kAppBarHeightLandscape;

  @override
  Size get preferredSize {
    return Size.fromHeight(
        appBarHeight - _statusBarHeight + (kPowerBtnSize / 2.0));
  }
}

class _MainAppBarState extends State<MainAppBar> {
  Status currentStatus;

  Color barColor;
  Color iconColor;

  double tooltipOpacity;
  double tooltipOffset;

  double connectedOpacity;

  String tooltipLabel;
  Color tooltipColor;

  var currentTheme;

  @override
  void initState() {
    super.initState();
    ConnectionModel connectionModel = Provider.of(context, listen: false);
    currentStatus = connectionModel.status;
    barColor = widget._appbarBgrColor[getIndex(connectionModel.status)];
    iconColor = widget._appbarIconColor[getIndex(connectionModel.status)];

    tooltipOpacity = 0;
    tooltipOffset = 40;
    connectedOpacity = 0;
    tooltipLabel = '';
    tooltipColor = getCustomColor(context, APPBAR_ICON_COLOR_INACTIVE);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prepareStatus(currentStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionModel>(builder: (context, model, _) {
      if (currentStatus != model.status ||
          currentTheme !=
              Provider.of<ThemeChanger>(context, listen: false).getTheme()) {
        currentStatus = model.status;
        currentTheme =
            Provider.of<ThemeChanger>(context, listen: false).getTheme();

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          prepareStatus(currentStatus);
        });
      }

      return Semantics(
        container: true,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: getSystemUiOverlayStyle(context),
          child: Stack(
            children: <Widget>[
              buildContainer(),
              buildTooltip(context, model.status),
              buildPowerButton(context, model.status, widget.onPowerPressed),
              buildMenuButton(widget.onMenuPressed),

            ],
          ),
        ),
      );
    });
  }

  int getIndex(Status status) {
    switch (status) {
      case Status.CONNECTED:
        return 1;
      default:
        return 0;
    }
  }

  Widget buildContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            width: widget._screenWidth,
            height: widget.appBarHeight,
            decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(widget.cornerRadius)))),
      ],
    );
  }

  Widget buildTooltip(context, status) {
    return Stack(alignment: Alignment.topCenter, children: [
      AnimatedPositioned(
        duration: _tooltipAnimationDuration,
        bottom: kPowerBtnSize + kMargin - tooltipOffset,
        child: AnimatedOpacity(
          duration: _tooltipAnimationDuration,
          opacity: tooltipOpacity,
          child: AppTooltip(
              text: Text(
                tooltipLabel,
                style: TextStyle(color: tooltipColor),
              ),
              status: status,
              backgroundColor: getCustomColor(context, TOOLTIP_COLOR)),
        ),
      ),
      AnimatedPositioned(
        duration: _tooltipAnimationDuration,
        bottom: kPowerBtnSize +
            kMargin / 2 +
            kTooltipHeight / 2 +
            50 -
            tooltipOffset,
        child: AnimatedOpacity(
          duration: _tooltipAnimationDuration,
          opacity: connectedOpacity,
          child: Text(
            S.of(context).tooltipConnected.toUpperCase(),
            style: uiTextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      )
    ]);
  }

  String getTooltipLabel(context, status) {
    switch (status) {
      case Status.CONNECTED:
        return S.of(context).tooltipConnected.toUpperCase();
      case Status.DISCONNECTING:
        return S.of(context).tooltipDisconnecting;
      case Status.DISCONNECTED:
        return S.of(context).tooltipDisconnected;
      case Status.CONNECTING:
        return S.of(context).tooltipConnecting;
      case Status.DISCONNECTED:
      default:
        return S.of(context).tooltipClickToConnect;
    }
  }

  Widget buildPowerButton(
      BuildContext context, Status status, VoidCallback onPressed) {
    return Positioned(
        bottom: 0,
        left: (widget._screenWidth - kPowerBtnSize) / 2.0,
        child: PowerButton(
          context,
          size: kPowerBtnSize,
          status: status,
          onPressed: onPressed,
        ));
  }

  Widget buildMenuButton(VoidCallback onPressed) {
    return Positioned(
      child: SizedBox(
        height: 100,
        child: AppBar(
          brightness: Theme.of(context).brightness,
          automaticallyImplyLeading: false,
        backgroundColor: barColor,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 15),
                  padding: EdgeInsets.all(0),
                  child: IconButton(
                    highlightColor:
                    Theme.of(context).appBarTheme.iconTheme.color.withAlpha(100),
                    icon: svgIcon(
                    asset: "assets/svgs/menu.svg",
                    color: iconColor,
                      size: 20.0,
                    ),
                    onPressed: onPressed,
                  ),
                ),
              ),
            ],
          ),
          elevation: 0,
        )
      )
    );
  }

  void prepareStatus(Status status) {
    if (status == Status.CONNECTED) {
      Future.delayed(_connectionAnimationDelay, () {
        setState(() {
          ConnectionModel connectionModel = Provider.of(context, listen: false);

          barColor = widget._appbarBgrColor[getIndex(connectionModel.status)];
          iconColor = widget._appbarIconColor[getIndex(connectionModel.status)];

          tooltipOpacity = 0;
          tooltipOffset = 40;
          connectedOpacity = 1;
          tooltipColor = getCustomColor(context, APPBAR_ICON_COLOR_INACTIVE);
        });
      });
    } else {
      setState(() {
        ConnectionModel connectionModel = Provider.of(context, listen: false);

        barColor = widget._appbarBgrColor[getIndex(connectionModel.status)];
        iconColor = widget._appbarIconColor[getIndex(connectionModel.status)];

        tooltipOpacity = 1;
        tooltipOffset = 0;
        connectedOpacity = 0;

        tooltipLabel = getTooltipLabel(context, connectionModel.status);
        tooltipColor = getCustomColor(
            context,
            status == Status.DISCONNECTED
                ? TOOLTIP_ALERT_COLOR
                : APPBAR_ICON_COLOR_INACTIVE);
      });
    }
  }
}
