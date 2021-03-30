import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/blocks/settings_model.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/navigation_helper.dart';
import 'package:wevpn/screens/settings/radio_row.dart';
import 'package:wevpn/theme/theme.dart';

import '../../theme/styles.dart';

class SelectPlanStep extends StatefulWidget {

  @override
  State createState() => _SelectPlanStepState();
}

class _SelectPlanStepState extends State<SelectPlanStep> {

  Plan selectedPlan;
  List<Plan> plans;
  List<_WhyItem> whyItems;
  bool showDetails;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    showDetails = false;
    _scrollController = ScrollController();
    plans = Provider.of<AccountModel>(context, listen: false).plans;
    selectedPlan = plans.first;
  }

  @override
  Widget build(BuildContext context) {

    whyItems = [
      _WhyItem('assets/svgs/w-devices.svg', S.of(context).getStartedWhyTitle1, S.of(context).getStartedWhySubtitle1, 6),
      _WhyItem('assets/svgs/w-incognito.svg', S.of(context).getStartedWhyTitle2, S.of(context).getStartedWhySubtitle2, 5),
      _WhyItem('assets/svgs/w-play.svg', S.of(context).getStartedWhyTitle3, S.of(context).getStartedWhySubtitle3, 4),
      _WhyItem('assets/svgs/w-no-logs.svg', S.of(context).getStartedWhyTitle4, S.of(context).getStartedWhySubtitle4, 4),
    ];

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyle(context),
        child: LayoutBuilder(
          builder: (context, viewportConstraints) => SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight/* - 28*/,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 60, 12, 16 ),
                child: Row(
                mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    logoImage(context, width: 91.2, height: 29.23),

                    Padding(
                      padding: EdgeInsets.only(right:1),
                      child: closeIconButton(() {
                      Navigator.of(context).pop();
                    })),
                  ],
                )),
                Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 12),
                  child: Text(
                    S
                        .of(context)
                        .getStartedSelectPlan,
                    style: Theme
                        .of(context)
                        .textTheme
                        .title,
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 12, right: 14, top:6, bottom: 12),
                  margin: EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: getCustomColor(context, SELECT_PLAN_BACKGROUND),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme,
                      toggleButtonsTheme: Theme.of(context).toggleButtonsTheme.copyWith(
                        fillColor: getCustomColor(context, SELECT_PLAN_TOGGLE_BACKGROUND)
                      ),
                      dividerTheme: Theme.of(context).dividerTheme.copyWith(
                        color: getCustomColor(context, SELECT_PLAN_DIVIDER_COLOR)
                      ),
                      textTheme: Theme.of(context).textTheme,
                    ),
                    child: _buildPlans(),
                  )
                ),
                _buildTrialInfo(context, selectedPlan),
                raisedButton(label: S
                    .of(context)
                    .getStartedBuyButton, onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pushNamed(NavigationRoute.VpnProfile.path);
                }),

                ] + _buildWhySubscribe(),
    ),
              ),
            ),
          ),
        ),
      ));
  }

  Widget _planRow(BuildContext context,
      {Plan value, Plan groupValue, String title, String subtitle, String badge}) {
    return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          RadioRow(
            value: value,
            groupValue: groupValue,
            title: title,
            subtitle: subtitle,
            onChanged: (value) => setState(() => selectedPlan = value ),
            condensed: false,
          ),
        ] + (badge != null ? [
          Container(
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .secondaryHeaderColor,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            margin: EdgeInsets.only(right: 11, top: 13),
            padding: EdgeInsets.fromLTRB(4, 3, 3, 1),
            child: Text(badge, style: Theme
                .of(context)
                .textTheme
                .display2,),
          ),
        ] : [])
    );
  }

  Widget _buildTrialInfo(context, Plan plan) {
    return Container(
      height: 59,
      padding: EdgeInsets.only(top:7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(plan.trialDaysTitle, style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.w600),),
          SizedBox(height: 1,),
          Text(plan.trialDaysSubtitle, style: Theme
              .of(context)
              .textTheme
              .subtitle
              .merge(TextStyle(
              color: Theme
              .of(context)
              .colorScheme
              .onSurface)),),
        ],
      ),
    );
  }

  Widget _buildPlans() {
    List<Widget> list = plans.expand((plan) => [
      _planRow(context, value: plan, groupValue: selectedPlan, title: plan.name, subtitle: plan.description, badge: plan.badge),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12).copyWith(top: 13, bottom: 4),
        child:Divider()
      ),
    ]).toList();
    list.removeLast();

    return Column(
        children: list
    );
  }

  List<Widget> _buildWhySubscribe() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 18, bottom: 7),
        child: Text(S.of(context).getStartedWhySubscribe,
          style: Theme.of(context).textTheme.subhead,
        ),
      )
    ] + _buildWhyPrimaryItem() + [
      Container(
        margin: EdgeInsets.only(top: 23, left: 1,bottom:0),
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [tinyFlatButton(
              context, S.of(context).getStartedSubscriptionDetailsTitle, () {
                setState(() {
                  showDetails = !showDetails;
                  if (showDetails) {
                    _scrollController.animateTo(330.0,
                        duration: Duration(milliseconds: 500), curve: Curves.ease);
                  }
                });
              },
              icon: Padding(
                padding: EdgeInsets.only(left: 7, top: 2),
                child: SvgPicture.asset(showDetails ? "assets/svgs/a-up.svg" : "assets/svgs/a-down.svg", width: 8, ),
              )
          )],
        ),
      ),
    ] + _buildSubscriptionDetailItems();
  }

  List<Widget> _buildWhyPrimaryItem() {
    return whyItems.map((item) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 24,
          height: 45,
          alignment: Alignment.topRight,
          child: Padding(padding: EdgeInsets.only(top: item.iconTopPadding),child: SvgPicture.asset(item.iconPath)),
        ),
        Container(
          margin: EdgeInsets.only(left: 8, top:5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 1), child: Text(item.title, style: Theme.of(context).textTheme.body1,)),
              Text(item.subtitle, style: Theme.of(context).textTheme.subtitle.copyWith(height:1.3, color: Theme.of(context).colorScheme.onSurface),),
            ],
          ),
        ),
      ],
    )).toList();
  }

  List<Widget> _buildSubscriptionDetailItems() {
    if (showDetails) {
      return S
          .of(context)
          .getStartedSubscriptionDetails
          .split('\n')
          .map<Widget>((line) {
        return
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '•',
                style: Theme.of(context).textTheme.subtitle,
                children: [
                  TextSpan(text: ' ', style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12)),
                  TextSpan(text: line),
                ]
              ),
            ),
          );
      }).toList() + [

        SizedBox(
          height: 27,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -2,
                child: htmlWithLinks(context, S.of(context).getStartedSubscriptionFooter, textAlign: TextAlign.left, padding: EdgeInsets.all(0)),
              )
            ],
          ),
        ),
        SizedBox(height: 24,)
      ];
    } else {
      return [
        SizedBox(height: 16,)
      ];
    }
  }
}

class Plan {
  final int id;
  final String name;
  final String otherName;
  final String description;
  final String badge;
  final String trialDaysTitle;
  final String trialDaysSubtitle;

  Plan({this.id,
    this.name, this.otherName, this.description, this.badge, this.trialDaysTitle, this.trialDaysSubtitle});
}

class _WhyItem {
  final String iconPath;
  final String title;
  final String subtitle;
  final double iconTopPadding;

  _WhyItem(this.iconPath, this.title, this.subtitle, this.iconTopPadding);
}