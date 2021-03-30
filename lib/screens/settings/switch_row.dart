import 'package:flutter/material.dart';
import 'package:wevpn/widgets/custom_switch.dart';

class SwitchRow extends StatelessWidget {

  final bool value;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;
  final EdgeInsets padding;
  final double toggleHeight;
  final bool bold;

  const SwitchRow({Key key, this.value, this.title, this.subtitle, this.onChanged, this.padding, this.toggleHeight = 48, this.bold = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .body1;
    if (bold) {
      titleStyle = titleStyle.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        fontSize: 13.0,
      );
    }
    TextStyle subtitleStyle = Theme
        .of(context)
        .textTheme
        .subtitle
        .merge(TextStyle(fontSize: 12, height: 1.3, color: Theme
        .of(context)
        .colorScheme
        .onSurface));

    double topTitlePadding = toggleHeight * 0.5 - 10 ;

    return
      InkWell(
          onTap: () => onChanged(!value),
          child: Padding(
            padding: padding ?? EdgeInsets.all(0),
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:
                <Widget>[

                Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 4, right: 12), child: CustomSwitch(checked: value)),
                  Padding(
                    padding: EdgeInsets.only(top: topTitlePadding),
                    child: Text(title, style: titleStyle)
                  ),
              ],
            ),] +
                    (subtitle != null ? [
                  Padding(
                      padding: EdgeInsets.only(bottom: 15, top: 4),
                      child: Text(subtitle, style: subtitleStyle)
                  )
          ] : [
            Container()
                ]))
      ));
  }
}