import 'package:flutter/material.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/theme/styles.dart';

typedef ValidatorCallback = bool Function(dynamic value);
typedef OnFocusChange = Function(bool hasFocus);

const Color kAppInputFieldValidColor = Color(0xFF08AE7E);
const Color kAppInputFieldInvalidColor = Color(0xFFF04545);

class AppInputField extends StatefulWidget {
  final bool isPassword;
  final Widget suffixIcon;
  final hintText;
  final String leftLabel;
  final String rightLabel;
  final TextStyle leftLabelStyle;
  final TextStyle rightLabelStyle;
  final VoidCallback onTapRightLabel;
  final Widget rightLabelWidget;
  final TextAlign textAlign;
  final ValueChanged<String> onChanged;
  final ValidatorCallback validate;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final OnFocusChange onFocusChange;
  final EdgeInsets contentPadding;

  const AppInputField({
    Key key,
    this.isPassword = false,
    this.suffixIcon,
    this.hintText,
    this.leftLabelStyle,
    this.rightLabelStyle,
    this.leftLabel,
    this.rightLabel,
    this.onTapRightLabel,
    this.textAlign,
    this.onChanged,
    this.textInputType,
    this.textInputAction,
    this.rightLabelWidget,
    this.validate,
    this.onFocusChange,
    this.contentPadding,
  }) : super(key: key);

  @override
  AppInputFieldState createState() => AppInputFieldState();
}

class AppInputFieldState extends State<AppInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _passwordVisible;
  FocusNode _focusNode;
  Color _hintColor;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged(_controller.text);
      }
    });
    _passwordVisible = false;
    _focusNode = new FocusNode();
    _focusNode.addListener(_onLoginFocus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hintColor = Theme.of(context).hintColor;
  }

  void _onLoginFocus() {
    bool hasFocus = _focusNode.hasFocus;
    if (widget.onFocusChange != null) {
      widget.onFocusChange(hasFocus);
    }
    _hintColor = hasFocus
        ? Theme.of(context).hintColor.withAlpha(178) // 70%
        : Theme.of(context).hintColor;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextEditingController get controller => _controller;

  bool isValid() =>
      widget.validate != null ? widget.validate(_controller.text) : true;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Column(
      children: <Widget>[
        buildLabels(strings, context),
        Stack(
          children: <Widget>[
            TextField(
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontWeight: FontWeight.w600),
              controller: _controller,
              maxLines: 1,
              textAlign: widget.textAlign ?? TextAlign.left,
              decoration: buildInputDecoration(context),
              obscureText: widget.isPassword && !_passwordVisible,
              keyboardType: widget.textInputType ?? TextInputType.text,
              textInputAction: widget.textInputAction,
              focusNode: _focusNode,
              enableSuggestions: false,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                child: widget.suffixIcon ?? buildIcon(context),
              ),
            )
          ],
        )
      ],
    );
  }

  bool _textIsNotEmpty(String text) {
    return text?.isNotEmpty ?? false;
  }

  Widget buildLabels(S strings, BuildContext context) {
    bool hasLeftLabelText = _textIsNotEmpty(widget.leftLabel);
    bool hasRightLabelText = _textIsNotEmpty(widget.rightLabel);
    return (hasLeftLabelText ||
            hasRightLabelText ||
            widget.rightLabelWidget != null)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              hasLeftLabelText
                  ? Container(
                      padding: EdgeInsets.only(
                          left: 0.0, top: 14.0, right: 0.0, bottom: 12.0),
                      child: Text(
                        widget.leftLabel ?? '',
                        style: widget.leftLabelStyle ??
                            Theme.of(context).textTheme.body1,
                      ),
                    )
                  : Container(),
              buildRightLabelWidget(hasRightLabelText, context),
            ],
          )
        : Container();
  }

  Widget buildRightLabelWidget(bool hasRightLabel, BuildContext context) {
    return widget.rightLabelWidget ??
        (hasRightLabel
            ? GestureDetector(
                onTap: widget.onTapRightLabel,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(
                      left: 0.0, top: 14.0, right: 0.0, bottom: 12.0),
                  child: Text(
                    widget.rightLabel ?? '',
                    style: widget.rightLabelStyle ??
                        Theme.of(context).textTheme.body1,
                  ),
                ),
              )
            : Container());
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      contentPadding: widget.contentPadding ??
          EdgeInsets.only(left: 16.0, right: widget.isPassword ? 32.0 : 16.0),
      hintStyle: Theme.of(context)
          .textTheme
          .body1
          .copyWith(fontWeight: FontWeight.w400, color: _hintColor),
      hintText: widget.hintText,
      enabledBorder: _inputBorder(),
      focusedBorder: InputBorder.none,
    );
  }

  InputBorder _inputBorder() {
    if (widget.validate == null || _controller.text.isEmpty) {
      return InputBorder.none;
    } else if (widget.validate(_controller.text)) {
      return UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: kAppInputFieldValidColor));
    } else {
      return UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: kAppInputFieldInvalidColor));
    }
  }

  Widget buildIcon(BuildContext context) {
    return widget.isPassword
        ? GestureDetector(
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(8.0),
              child: svgIconGeneral(
                  asset: (!_passwordVisible
                      ? 'assets/svgs/eye.svg'
                      : 'assets/svgs/b-eye.svg'),
                  color: Theme.of(context).textTheme.body1.color,
                  width: 16.0,
                  height: 16.0,
                  fit: BoxFit.contain),
            ),
            onTap: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            })
        : Container();
  }
}
