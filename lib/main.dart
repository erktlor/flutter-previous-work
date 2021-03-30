import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/connection_model.dart';
import 'package:wevpn/blocks/locations_model.dart';
import 'package:wevpn/blocks/theme_changer.dart';
import 'package:wevpn/blocks/version_model.dart';
import 'package:wevpn/navigation_helper.dart';
import 'package:wevpn/screens/screens.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';

import 'blocks/settings_model.dart';
import 'blocks/stats_model.dart';
import 'generated/i18n.dart';
import 'screens/intro.dart';

void main() => runApp(WeVPNApp());

class WeVPNApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChanger>(
            create: (_) => ThemeChanger()..init()),
        ChangeNotifierProvider<SettingsProtocolModel>(
          create: (_) => SettingsProtocolModel(),
        ),
        ChangeNotifierProvider<SettingsConnectionModel>(
          create: (_) => SettingsConnectionModel(),
        ),
        ChangeNotifierProvider<SettingsPrivacyModel>(
          create: (_) => SettingsPrivacyModel(),
        ),
        ChangeNotifierProvider<SettingsAutoUpdateModel>(
          create: (_) => SettingsAutoUpdateModel(),
        ),
        ChangeNotifierProvider<AccountModel>(
          create: (_) => AccountModel()..start(),
        ),
        ChangeNotifierProvider<ConnectionModel>(
          create: (_) => ConnectionModel(),
        ),
        ChangeNotifierProxyProvider<ConnectionModel, StatsModel>(
          create: (_) => StatsModel(),
          update: (context, connectionModel, statsModel) =>
              statsModel..update(connectionModel.status),
        ),
        ChangeNotifierProvider<VersionModel>(
          create: (_) => VersionModel()..readPlatformVersion(),
        ),
        ChangeNotifierProxyProvider<ConnectionModel, LocationsModel>(
          create: (_) => LocationsModel()..init(),
          update: (context, connectionModel, locationsModel) =>
              locationsModel..updateStatus(connectionModel.status),
        ),
      ],
      child: MaterialDesignApp(),
    );
  }
}

class MaterialDesignApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Consumer<AccountModel>(
        builder: (context, accountModel, _) => MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: AppBehavior(),
              child: child,
            );
          },
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          showSemanticsDebugger: false,
          title: 'We VPN',
          theme: theme.getTheme(),
          home: NavigationHelper.getWidget(accountModel.initialRoute),
//          home: SplashScreen(),
          localizationsDelegates: [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          onGenerateRoute: NavigationHelper.generateRoute,
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyle(context),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              raisedButton(
                  label: 'light theme',
                  onPressed: () => _themeChanger.setTheme(lightTheme)),
              SizedBox(
                height: 10,
              ),
              raisedButton(
                  label: 'dark theme',
                  onPressed: () => _themeChanger.setTheme(darkTheme)),
              SizedBox(
                height: 10,
              ),
              raisedButton(
                  label: 'splashscreen',
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()))),
              SizedBox(
                height: 10,
              ),
              raisedButton(
                  label: 'intro',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Intro()));
                  }),
              SizedBox(
                height: 10,
              ),
              raisedButton(
                  label: 'login',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  }),
              SizedBox(
                height: 10,
              ),
              raisedButton(
                  label: 'settings',
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(NavigationRoute.Settings.path);
                  }),
              SizedBox(
                height: 10,
              ),
              raisedButton(
                  label: 'main',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Main()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
class AppBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}