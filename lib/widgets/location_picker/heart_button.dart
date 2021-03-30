import 'package:flutter/material.dart';
import 'package:wevpn/theme/styles.dart';

const _heartAsset = "assets/svgs/heart.svg";
const _heartAssetEmpty = "assets/svgs/heart-empty.svg";

typedef HeartCallback = void Function(bool filled);

class HeartButton extends StatefulWidget {
  final Color color;
  final Color colorEmpty;
  final HeartCallback onChange;

  HeartButton(
      {Key key, @required this.color, @required this.colorEmpty, this.onChange})
      : super(key: key);

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  String _assetName;
  Color _currentColor;

  @override
  void initState() {
    super.initState();
    _assetName = _heartAssetEmpty;
    _currentColor = widget.colorEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 48.0,
        height: 48.0,
        child: MaterialButton(
          elevation: 10.0,
          shape: CircleBorder(),
          onPressed: () => click(),
          highlightColor: _currentColor.withAlpha(100),
          child: Center(
            child: svgIconGeneral(
              asset: _assetName,
              color: _currentColor,
              width: 16.0,
              height: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  click() {
    bool state = _assetName == _heartAssetEmpty;
    if (widget.onChange != null) {
      widget.onChange(state);
    }
    setState(() {
      _assetName = state ? _heartAsset : _heartAssetEmpty;
      _currentColor = state ? widget.color : widget.colorEmpty;
    });
  }
}
