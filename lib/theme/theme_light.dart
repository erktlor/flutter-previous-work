part of 'theme.dart';

ThemeData _buildLightTheme() {
  const Color primaryColor = Color(0xFFFD3E72);
  const Color onPrimaryColor = Color(0xFFFCF9F2);
  const Color backgroundColor = Color(0xFFFFFFFF); // for Checkboxes on Settings page
  const Color scaffoldBackgroundColor = Color(0xFFF9F8F4);
  const Color surfaceColor = Color(0xFFF5F3ED);
  const Color textColor = Color(0xFF5B5863);
  const Color highlightColor = Color(0xFFF5F3ED);
  const Color splashColor = Color(0xFFF5F3ED);
  const Color progressIndicatorColor = Color(0xFFC7C4BC);
  const Color buttonColor = primaryColor;
  const Color cursorColor = Color(0xFF5B5863);
  const Color hintTextColor = Color(0xFFAFADB2);
  const Color inputFieldColor = Color(0xFFFFFFFF);
  const Color dialogBackgroundColor = Color(0xFFF9F8F4);
  const Color dialogOverlayBackgroundColor = Color(0xCC5E5B55);
  const Color dialogTitleColor = primaryColor;
  const Color dialogContentColor = Color(0xFF5B5863);
  const Color dropDownBackgroundColor = Color(0xFFFFFFFF); // DropDownColors
  const Color badgeColor = Color(0xFF50BF9F); // badge color
  const Color subtitleColor = Color(0XFF969599);
  const Color unselectedWidgetColor = Color(0xFFD4D2CC);
  const Color dividerColor = Color(0xFFEDEBE5);
  const Color settingsHeaderRowColor = hintTextColor;

  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      secondary: primaryColor,
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
      brightness: Brightness.light,
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      accentColor: colorScheme.primary,
      fontFamily: 'Averta',
      textTheme: textTheme(textColor, primaryColor, settingsHeaderRowColor, hintTextColor),
      indicatorColor: progressIndicatorColor,
      unselectedWidgetColor: unselectedWidgetColor,
      toggleableActiveColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: textColor,
          size: 80,
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
          padding: EdgeInsets.fromLTRB(10, 3, 10, 0)),
      inputDecorationTheme:
          inputDecorationTheme(inputFieldColor, hintTextColor),
      cursorColor: cursorColor,
      dialogBackgroundColor: dialogBackgroundColor,
      dialogTheme: dialogTheme(dialogTitleColor, dialogContentColor, dialogOverlayBackgroundColor),
  );
}

