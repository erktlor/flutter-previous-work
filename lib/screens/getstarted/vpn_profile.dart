import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/navigation_helper.dart';
import 'package:wevpn/theme/styles.dart';

import '../../theme/theme.dart';

class VpnProfileStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: getSystemUiOverlayStyle(context),
      child: LayoutBuilder(
       builder: (context, viewportConstraints) => SingleChildScrollView(
        padding: EdgeInsets.symmetric( horizontal: 40),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight/* - 28*/,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  logoImage(context,height: 41),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          width: 136,
                          height: 136,
                          margin: EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getCustomColor(context, CONFIG_BACKGROUND_COLOR),
                          ),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 58,
                            height: 62,
                            child: SvgPicture.asset(
                              'assets/svgs/vpn-profile-image.svg',
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 27, bottom: 12),
                            child: Text(
                              S.of(context).vpnProfileTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.title,
                            )),
                        Text(
                          S.of(context).vpnProfileText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
//                  Flexible(
//                    child: Container(),
//                  ),
                  raisedButton(
                      label: S.of(context).vpnProfileContinue,
                      onPressed: () {
                        Navigator.of(context).pushNamed(NavigationRoute.ChooseTheme.path);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    ));
  }
}
