import 'package:flutter/material.dart';
import 'package:wevpn/widgets/custom_radio.dart';

class RadioRow<T> extends StatelessWidget {

  final T value;
  final T groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<T> onChanged;
  final EdgeInsets padding;
  final bool condensed;
  final double toggleHeight;

  const RadioRow({Key key, this.value, this.groupValue, this.title, this.subtitle, this.onChanged, this.padding, this.condensed : true, this.toggleHeight = 48}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle.merge(
        TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 12, height: 1.3,
        )
    );
    if (condensed) {
      titleStyle = titleStyle.copyWith(fontSize: 13);
      subtitleStyle = subtitleStyle.copyWith(fontSize: 12);
    }

    double topTitlePadding = toggleHeight * 0.5 - 8 + (condensed ? 1 : -1);

    return
    InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: padding ?? EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height:toggleHeight,
              child: CustomRadio(value: value, groupValue: groupValue, onChanged: onChanged, ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:
              subtitle != null ?
              [
                Padding(
                    padding: EdgeInsets.only(top: topTitlePadding),
                    child: Text(title, style: titleStyle)
                ),

                Padding(
                    padding: EdgeInsets.only(bottom: condensed ? 3 : 0, top: condensed ? 8 : 1),
                    child: Text(subtitle, style: subtitleStyle)
                ),
              ] : [
                Padding(
                    padding: EdgeInsets.only(top: topTitlePadding),
                    child: Text(title, style: titleStyle)
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}