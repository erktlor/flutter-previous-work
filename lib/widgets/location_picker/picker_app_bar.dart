import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/theme/styles.dart';

const double kTabHorizontalMargin = 60.0;
const double kBottomMargin = 32.0;
const double kContentMargin = 40.0;

class PickerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController textEditingController;

  PickerAppBar(BuildContext context, {Key key, this.textEditingController})
      : preferredSize = Size.fromHeight(
            statusBarHeight(context) + 2 * kToolbarHeight + kBottomMargin),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    var localization = S.of(context);
    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyle(context),
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).appBarTheme.color,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 1, top:0, right: 32),
                      height: 76,
                      color: Theme.of(context).appBarTheme.color,
                      child: AppBar(
                        brightness: Theme.of(context).brightness,
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: EdgeInsets.only(top:18),
                          child: Row(
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
                                    localization.locationPickerTitle,
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                width: 30,
                              )
                            ],
                          ),
                        ),
                        elevation: 0,
                      )),
                  buildSearchField(context, localization),
                  SizedBox(
                    height: kBottomMargin,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(context, S localization) => Expanded(
          child: Text(
        localization.locationPickerTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline,
      ));

  Widget buildSearchField(BuildContext context, S localization) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kContentMargin, 0, kContentMargin, 0),
      child: Container(
        height: 40.0,
        child: TextField(
          controller: textEditingController,
          style: Theme.of(context).textTheme.body1,
          maxLines: 1,
          textAlignVertical: TextAlignVertical(y: 0.0),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15.5,
            ).copyWith(bottom: 7),
            hintText: localization.locationPickerSearchHint,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/zoom.svg',
                    width: 15,
                    color: Theme.of(context).textTheme.body1.color,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
