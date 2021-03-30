import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/navigation_helper.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';
import 'package:wevpn/widgets/intro_slider.dart';

import '../blocks/settings_model.dart';
import '../generated/i18n.dart';

class Intro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  void onDonePress() {
    // Do what you want
  }

  @override
  Widget build(BuildContext context) {
    List<Slide> slides = _buildSlides();
    return AnnotatedRegion(
      value: getSystemUiOverlayStyle(context),
      child: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;
          if (isLandscape) {
            return Scaffold(
              body: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(child: buildIntroSlider(context, slides: slides)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: separatorVertical(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          topButton(context),
                          bottomButton(context)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Scaffold(
                body: buildIntroSlider(context, slides: slides),
                bottomNavigationBar: Container(
                  margin: EdgeInsets.only(top: 16),
                  height: 135,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(width: double.infinity ,padding: EdgeInsets.symmetric(horizontal: 40),child: topButton(context)),
                      Positioned(
                        top: 57,
                        child: Padding(padding: EdgeInsets.only(left: 14),child: bottomButton(context)),
                      )
                    ],
                  )
                ));
          }
        },
      ),
    );
  }

  Row bottomButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        primaryFlatButtonExternal(context, () {
            Provider.of<AccountModel>(context).introPassed(needLogin: true);
          },
          title: Row(
            children: <Widget>[
              Text(
                S.of(context).onboardingExistingUser,
                style: Theme.of(context).textTheme.body2,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                S.of(context).onboardingLogin,
                style: Theme.of(context).textTheme.body2,
              ),
            ]
          )
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget topButton(BuildContext context) {
    return raisedButton(
      label: S.of(context).onboardingStartTrial,
      onPressed: () {
        Navigator.of(context).pushNamed(NavigationRoute.StartTrial.path);
        Provider.of<AccountModel>(context).introPassed();
      },
    );
  }

  Widget buildIntroSlider(BuildContext context, {List<Slide> slides}) {
    return CustomIntroSlider(
      slides: slides,
      onDonePress: this.onDonePress,
      listCustomTabs: this.renderListCustomTabs(slides),
      colorDot: Theme.of(context).hintColor,
      colorActiveDot: Theme.of(context).primaryColor,
    );
  }

  List<Slide> _buildSlides() {
    List<Slide> slides = [
      [
        S.of(context).onboardingOneTitle,
        S.of(context).onboardingOneSubtitle,
        "assets/images/onboarding1.png"
      ],
      [
        S.of(context).onboardingTwoTitle,
        S.of(context).onboardingTwoSubtitle,
        "assets/images/onboarding2.png"
      ],
      [
        S.of(context).onboardingThreeTitle,
        S.of(context).onboardingThreeSubtitle,
        "assets/images/onboarding3.png"
      ],
      [
        S.of(context).onboardingFourTitle,
        S.of(context).onboardingFourSubtitle,
        "assets/images/onboarding4.png"
      ],
    ].map((data) => _buildSlide(data[0], data[1], data[2])).toList();

    return slides;
  }

  Slide _buildSlide(String title, String description, String imagePath) {
    return Slide(
      title: title,
      styleTitle: Theme.of(context).textTheme.subhead,
      description: description,
      styleDescription: Theme.of(context).textTheme.body1.copyWith(color: getCustomColor(context, INTRO_DESCRIPTION_COLOR)),
      pathImage: imagePath,
    );
  }

  List<Widget> renderListCustomTabs(List<Slide> slides) {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                    child: Padding(
                  padding: EdgeInsets.only(top: 53, bottom: 24),
                  child: Image.asset(
                    currentSlide.pathImage,
                    fit: BoxFit.contain,
                  ),
                )),
              ),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(bottom: 1.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(bottom: 30.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }
}
