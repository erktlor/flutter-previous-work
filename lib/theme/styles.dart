import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wevpn/blocks/theme_changer.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/theme/theme.dart';
import 'package:wevpn/widgets/input_field/app_input_field.dart';

double screenHeight(context) => MediaQuery.of(context).size.height;

double screenWidth(context) => MediaQuery.of(context).size.width;

double statusBarHeight(context) => MediaQuery.of(context).padding.top;

bool isLightTheme(context) => Theme.of(context).brightness == Brightness.light;

Widget logoImage(context, {double width: 187.2, double height: 60.0}) =>
    SvgPicture.asset(
        "assets/svgs/logo/logo_${isLightTheme(context) ? 'light' : 'dark'}.svg",
        width: width,
        height: height,
        semanticsLabel: 'LOGO IMAGE');

Color getCustomColor(context, int key) {
  ThemeChanger themeChanger = Provider.of<ThemeChanger>(context, listen: false);
  return themeChanger.getAppThemeColors().getColor(key);
}

SystemUiOverlayStyle getSystemUiOverlayStyle(context) => isLightTheme(context)
    ? SystemUiOverlayStyle.dark
    : SystemUiOverlayStyle.light;

Widget raisedButton({Key key, label, VoidCallback onPressed, Widget icon}) {
  Widget text = Text(label, semanticsLabel: '$label BUTTON');
  return icon != null
      ? RaisedButton.icon(
          key: key,
          icon: icon,
          label: text,
          elevation: 0,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(0.0),
          ),
        )
      : RaisedButton(
          key: key,
          child: text,
          elevation: 0,
          onPressed: () {
            if (onPressed != null) onPressed();
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(0.0),
          ),
        );
}

Widget primaryFlatButton(
    BuildContext context, String text, VoidCallback onPressed,
    {Widget icon, EdgeInsetsGeometry iconPadding }) {
  if (icon == null) {
    icon = Icon(
      Icons.play_arrow,
      size: 16,
    );
  }
  if (iconPadding == null) {
    iconPadding = EdgeInsets.only(left: 2);
  }
  return Theme(
      data: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
          minWidth: 50,
          height: 28,
        ),
        textTheme: Theme.of(context).textTheme,
      ),
      child: FlatButton(
        textColor: Theme.of(context).primaryColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 10),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            Text(
              text,
            ),
            Padding(padding: iconPadding,child: icon),
          ],
        ),
        onPressed: onPressed,
      ));
}


Widget primaryFlatButtonExternal(
    BuildContext context, VoidCallback onPressed,
    {Widget title, Widget icon, EdgeInsetsGeometry iconPadding }) {
  if (icon == null) {
    icon = Icon(
      Icons.play_arrow,
      size: 16,
    );
  }
  if (iconPadding == null) {
    iconPadding = EdgeInsets.only(left: 2);
  }
  return Theme(
      data: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              minWidth: 50,
              height: 28,
            ),
        textTheme: Theme.of(context).textTheme,
      ),
      child: FlatButton(
        textColor: Theme.of(context).primaryColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 10),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            title,
            Padding(padding: iconPadding,child: icon),
          ],
        ),
        onPressed: onPressed,
      ));
}

Widget tinyFlatButton(BuildContext context, String text, VoidCallback onPressed,
    {Widget icon}) {
  if (icon == null) {
    icon = Icon(
      Icons.play_arrow,
      size: 16,
    );
  }
  return Theme(
      data: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(minWidth: 50),
        colorScheme: Theme.of(context).colorScheme,
      ),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 10),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.display1,
            ),
            icon,
          ],
        ),
        onPressed: onPressed,
      ));
}

Widget bottomBar(List<Widget> children) {
  return Padding(
    padding: EdgeInsets.only(left: 40, right: 40, bottom: 0, top: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    ),
  );
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget formLabel(context, {text}) => Text(
      text,
      style: Theme.of(context).textTheme.body1,
    );

Widget formLink(context, {text, String link, VoidCallback onPressed}) {
  return GestureDetector(
    onTap: () {
      launchURL(link);
      if (onPressed != null) onPressed();
    },
    child: Text(
      text,
      style: Theme.of(context).textTheme.body1.copyWith(
          decoration: TextDecoration.underline,
          color: getCustomColor(context, LINK_COLOR),
          backgroundColor: Colors.transparent,
        letterSpacing: -0.45,
      ),
    ),
  );
}

Widget formField(context,
        {hintText,
        TextEditingController controller,
        obscureText = false,
        Widget icon,
        VoidCallback onPressedIcon}) =>
    TextField(
      style: Theme.of(context).textTheme.body1,
      controller: controller,
      maxLines: 1,
      textAlignVertical: obscureText ? TextAlignVertical(y: 0.0) : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16,).copyWith(bottom: 4),
        hintText: hintText,
        suffixIcon: icon != null
            ? InkWell(
                child: icon,
                onTap: () {
                  if (onPressedIcon != null) onPressedIcon();
                },
              )
            : null,
      ),
      obscureText: obscureText,
    );


Widget buildLoginRightLabel(
    BuildContext context, AppInputFieldState loginState) {
  if (loginState.isValid()) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
          left: 0.0, top: 14.0, right: 0.0, bottom: 12.0),
      child: Row(
        children: <Widget>[
          svgIconGeneral(
              asset: 'assets/svgs/valid.svg',
              color: kAppInputFieldValidColor,
              width: 8.8,
              height: 6.8),
          Text(
            S.of(context).labelValidEmail,
            style: Theme.of(context).textTheme.body1.copyWith(
              color: kAppInputFieldValidColor,
              letterSpacing: 0,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      margin: EdgeInsets.only(top: 3, right: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.5, ),
            child: svgIconGeneral(
                asset: 'assets/svgs/invalid.svg',
                color: kAppInputFieldInvalidColor,
                width: 2.0,
                height: 8.0),
          ),
          SizedBox(width: 2,),
          Text(
            S.of(context).labelInvalidEmail,
            style: Theme.of(context).textTheme.body1.copyWith(
              color: kAppInputFieldInvalidColor,
              letterSpacing: 0,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}

Widget closeIconButton(VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: SvgPicture.asset('assets/svgs/c-remove.svg',
        semanticsLabel: 'close  button'),
  );
}

Widget htmlWithLinks(BuildContext context, String text,
    {TextAlign textAlign: TextAlign.center, EdgeInsets padding, double fontSize : 13.0}) {
  return Html(
    data: text,
    padding: padding,
    customTextAlign: (_) {
      return textAlign;
    },
    customTextStyle: (dom.Node node, TextStyle baseStyle) {
      baseStyle.merge(
        Theme.of(context).textTheme.subtitle,
      );
      if (node is dom.Element) {
        switch (node.localName) {
          case "a":
            return baseStyle
                .merge(Theme.of(context).textTheme.display1)  ;
          case "p":
            return baseStyle
                .merge(Theme.of(context).textTheme.subtitle
                .copyWith(fontSize: fontSize))  ;
          case "li":
            return baseStyle
                .merge(Theme.of(context).textTheme.subtitle
                .copyWith(fontSize: fontSize))  ;
        }
      }
      return baseStyle;
    },
    onLinkTap: (url) {
      launchURL(url);
    },
  );
}

TextStyle uiTextStyle(
    {Color color = Colors.white,
    double fontSize: 16.0,
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Segoe UI',
      fontWeight: fontWeight);
}

Widget backButton(context) {
  var appbarIconColor = Theme.of(context).appBarTheme.iconTheme.color;
  return Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: SizedBox(
      width: 54,
      height: 54,
      child: MaterialButton(
        elevation: 10.0,
        shape: CircleBorder(),
        onPressed: () => Navigator.of(context).pop(),
        highlightColor: appbarIconColor.withAlpha(100),
        child: backButtonIcon(context),
      ),
    ),
  );
}

Widget backButtonIcon(context) {
  var appbarIconColor = Theme.of(context).appBarTheme.iconTheme.color;
  return svgIcon(
    asset: "assets/svgs/a-back.svg",
    color: appbarIconColor,
  );
}

Widget menuButtonIcon(Color color) {
  return svgIcon(
    asset: "assets/svgs/menu.svg",
    color: color,
    size: 20.0
  );
}

Widget svgIcon({color = Colors.white, @required String asset, size = 24.0}) {
  return svgIconGeneral(asset: asset, color: color, width: size, height: size);
}

Widget svgIconGeneral(
    {color = Colors.white,
      @required String asset,
      width = 24.0,
      height = 24.0,
      fit = BoxFit.contain,
    }) {
  return SvgPicture.asset(
    asset,
    color: color,
    width: width,
    height: height,
    fit: fit,
  );
}

Widget settingsAppBar(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(71.5),
    child:
     Container(
       color: Theme.of(context).appBarTheme.color,
       padding: EdgeInsets.only(left: 1, top:8.5, right: 32),
         child:
      AppBar(
    brightness: Theme.of(context).brightness,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 14),
          padding: EdgeInsets.all(0),
          child: IconButton(
            highlightColor:
                Theme.of(context).appBarTheme.iconTheme.color.withAlpha(100),
            icon: backButtonIcon(context),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Expanded(
            child: Text(
          title,
          textAlign: TextAlign.center,
        )),
        SizedBox(
          width: 30,
        )
      ],
    ),
    elevation: 0,
  )));
}

Widget linkButton(BuildContext context, String text, {VoidCallback onPressed}) {
  return Theme(
      data: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(minWidth: 20),
      ),
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 0),
        // color the same in both themes and different font
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 13,
              color: Color(0xFF8F8D91),
              decoration: TextDecoration.underline),
        ),
        onPressed: onPressed,
      ));
}

Widget separatorHorizontal(context, {double size = 1.0}) => Container(
      height: size,
      color: Theme.of(context).dividerColor,
    );

Widget separatorVertical(context, {double size = 1.0}) => Container(
      width: size,
      color: Theme.of(context).dividerColor,
    );
