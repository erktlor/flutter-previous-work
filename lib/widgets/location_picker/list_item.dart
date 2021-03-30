import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wevpn/widgets/location_picker/location_picker.dart';

const double _kListItemHeight = 50.0;
const double _kListItemHorizontalMargin = 20.0;
const double _kListItemSpaceBetween = 10.0;

class ListItem extends StatelessWidget {
  final String asset;
  final String title;
  final bool isSelected;

  const ListItem(
      {Key key, this.asset, this.title = '', this.isSelected = false})
      : assert(asset != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.body1;
    return Container(
//      decoration: BoxDecoration(
//        color: getCustomColor(context, LOCATIONS_LIST_ITEM_BACKGROUND_COLOR),
//      ),
      padding: EdgeInsets.symmetric(horizontal: _kListItemHorizontalMargin),
      height: _kListItemHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildSelectedIcon(),
          buildFlagIcon(textStyle),
          SizedBox(
            width: _kListItemSpaceBetween,
          ),
          buildTitle(textStyle),
        ],
      ),
    );
  }

  Widget buildTitle(TextStyle textStyle) {
    if(isSelected){
      textStyle = textStyle.copyWith(color: kSelectedColor);
    }
    return Text(
      title,
      style: textStyle,
    );
  }

  Widget buildFlagIcon(TextStyle textStyle) {
    return SizedBox(
      width: 24,
      height: 18,
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildSelectedIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 11.0, top:4),
      child: SizedBox(
        width: 8.8,
        height: 6.8,
        child: isSelected
            ? SvgPicture.asset(
                'assets/svgs/valid.svg',
                color: kSelectedColor,
                fit: BoxFit.fill,
              )
            : Container(),
      ),
    );
  }
}
