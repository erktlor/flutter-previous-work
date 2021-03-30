part of 'theme.dart';

ThemeData _buildDarkTheme() {
  const Color primaryColor = Color(0xFFFD3E72);
  const Color backgroundColor = Color(0xFF3F3D45);   // for Checkboxes on Settings page
  const Color scaffoldBackgroundColor = Color(0xFF3F3D45);
  const Color surfaceColor = Color(0xFF36343B);
  const Color textColor = Color(0xFFC7C5C4);
  const Color highlightColor = Color(0xFF3A3840);
  const Color splashColor = Color(0xFF3A3840);
  const Color progressIndicatorColor = Color(0xFFFD3E72);
  const Color buttonColor = primaryColor;
  const Color cursorColor = Color(0xFFC7C5C4);
  const Color hintTextColor = Color(0xFF807E85);
  const Color inputFieldColor = Color(0xFF46444D);
  const Color dialogBackgroundColor = Color(0xFF3F3D45);
  const Color dialogOverlayBackgroundColor = Color(0xCC2C2B30);
  const Color dialogTitleColor = primaryColor;
  const Color dialogContentColor = Color(0xFFC7C5C4);
  const Color dropDownBackgroundColor = Color(0xFF36343B); // DropDownColors
  const Color badgeColor = Color(0xFF50BF9F); // badge color
  const Color subtitleColor = Color(0XFF7E7C80);
  const Color unselectedWidgetColor = dropDownBackgroundColor;
  const Color dividerColor = Color(0xFF38363D);
  const Color settingsHeaderTextColor = Color(0xFF626064);

  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
      primary: primaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      secondary: primaryColor,
      primaryVariant: primaryColor,
      onSurface: subtitleColor,
  );

  return ThemeData(
      secondaryHeaderColor: badgeColor,
      backgroundColor: colorScheme.background,
      cardColor: dropDownBackgroundColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      hintColor: hintTextColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      accentColor: colorScheme.primary,
      fontFamily: 'Averta',
      textTheme: textTheme(textColor, primaryColor, settingsHeaderTextColor, hintTextColor),
      indicatorColor: progressIndicatorColor,
      unselectedWidgetColor: unselectedWidgetColor,
      toggleableActiveColor: primaryColor,
      toggleButtonsTheme: ToggleButtonsThemeData(
        fillColor: surfaceColor,
      ),
      appBarTheme: AppBarTheme(
        color: surfaceColor,
        iconTheme: IconThemeData(
          color: textColor,
          size: 30,
        ),
        textTheme: TextTheme(
          title: TextStyle(fontSize: 18.0, color: textColor, fontFamily: 'Averta', fontWeight: FontWeight.w600),
        )
      ),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1.0,
        space: 0,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.primary,
        height: 48,
        minWidth: 154,
        padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
      ),
      inputDecorationTheme:
          inputDecorationTheme(inputFieldColor, hintTextColor),
      cursorColor: cursorColor,
      dialogBackgroundColor: dialogBackgroundColor,
      dialogTheme: dialogTheme(dialogTitleColor, dialogContentColor, dialogOverlayBackgroundColor));
}

