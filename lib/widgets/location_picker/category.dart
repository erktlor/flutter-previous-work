import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';

const double _kCategoryHeight = 36.0;
const double _kCategoryHorizontalMargin = 40.0;
const double _kCategoryDividerSize = 1.0;
const double _kCategorySpaceBetween = 8.0;

class Category extends StatelessWidget {
  final String asset;
  final String title;

  const Category({Key key, this.asset, this.title = ''})
      : assert(asset != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.display3;
    var divider = BorderSide(
      width: _kCategoryDividerSize,
      color: getCustomColor(context, LOCATIONS_LIST_DIVIDER_COLOR),
    );
    return Container(
      decoration: BoxDecoration(
        color:
            getCustomColor(context, LOCATIONS_LIST_CATEGORY_BACKGROUND_COLOR),
        border: Border(
          top: divider,
          bottom: divider,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: _kCategoryHorizontalMargin),
      height: _kCategoryHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildIcon(textStyle),
          SizedBox(
            width: _kCategorySpaceBetween,
          ),
          buildTitle(textStyle),
        ],
      ),
    );
  }

  Widget buildTitle(TextStyle textStyle) {
    return Text(
      title,
      style: textStyle.copyWith(fontSize: 12.0),
    );
  }

  Widget buildIcon(TextStyle textStyle) {
    return SizedBox(
      width: 16,
      height: 15.28,
      child: SvgPicture.asset(asset, color: textStyle.color, fit: BoxFit.fill,),
    );
  }
}
