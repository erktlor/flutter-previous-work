import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:wevpn/blocks/locations_model.dart';
import 'package:wevpn/generated/i18n.dart';
import 'package:wevpn/theme/styles.dart';
import 'package:wevpn/theme/theme.dart';
import 'package:wevpn/widgets/location_picker/category.dart';
import 'package:wevpn/widgets/location_picker/data/country.dart';
import 'package:wevpn/widgets/location_picker/data/locations.dart';
import 'package:wevpn/widgets/location_picker/list_item.dart';
import 'package:wevpn/widgets/location_picker/picker_app_bar.dart';
import 'package:wevpn/widgets/location_picker/scrollbar.dart';

const double kSeparatorMargin = 40.0;
const double iconMargin = 16.0;
const double kChooserCornerRadius = 5.0;
const double kChooserHeight = 90.0;
const double kChooserContentHeight = 53.0;
const double kWidgetHeight = 123.0;

const double kChooserLandscapeHeight = 70.0;
const double kWidgetLandscapeHeight = 100.0;

const Color kSelectedColor = const Color(0xFF08AE7E);

const kAssetsKeyboardArrowRight = 'assets/svgs/keyboard-arrow-right.svg';
const kAssetsLocationsBest = 'assets/svgs/locations-best.svg';
const kAssetsLocationsRecent = 'assets/svgs/locations-recent.svg';
const kAssetsLocationsAll = 'assets/svgs/locations-all.svg';

class LocationPicker extends StatelessWidget {
  Future show(BuildContext context) async {
    await showGeneralDialog<Country>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Theme.of(context).dialogTheme.backgroundColor,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) =>
          _PickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isLandscape = orientation == Orientation.landscape;
        return Consumer<LocationsModel>(
          builder: (context, model, _) {
            var serverLocationsLabel =
                "${model.serverLocations} ${S.of(context).locationPickerLocationsCount}";
            var textTheme = Theme.of(context).textTheme;
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              height: isLandscape ? kWidgetLandscapeHeight : kWidgetHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      serverLocationsLabel,
                      style: textTheme.subtitle.copyWith(
                          color: getCustomColor(
                              context, SERVER_LOCATIONS_COUNT_COLOR),
                          backgroundColor: Colors.transparent),
                    ),
                  ),
                  buildChooserButton(model, context, textTheme,
                      isLandscape ? kChooserLandscapeHeight : kChooserHeight),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildChooserButton(LocationsModel model, BuildContext context,
      TextTheme textTheme, double buttonHeight) {
    var backgroundColor = getCustomColor(context, PWR_BTN_BGR_COLOR_INACTIVE);
    return Container(
        child: Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kChooserCornerRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              show(context);
            },
            child: Container(
              height: buttonHeight,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 17.0),
                      height: kChooserContentHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 1.0),
                            child: Row(
                              children: <Widget>[
                                model.selectedLocation.isBest
                                    ? SizedBox(
                                        width: 12.0,
                                        height: 11.46,
                                        child: SvgPicture.asset(
                                          kAssetsLocationsBest,
                                          fit: BoxFit.fill,
                                          color: textTheme.caption.color,
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  model.selectedLocation.isBest
                                      ? S.of(context).locationPickerCaptionBest
                                      : S.of(context).locationPickerCaption,
                                  style: textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 2.0, bottom: 4.0),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 26.0,
                                  height: 20.0,
                                  child: SvgPicture.asset(
                                    model.selectedLocation.location.asset,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      model.selectedLocation.location.name,
                                      style: textTheme.headline,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 26, top: 3),
                    child: svgIconGeneral(
                        asset: kAssetsKeyboardArrowRight,
                        color: textTheme.caption.color,
                        width: 8.41,
                        height: 16.82),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class _PickerDialog extends StatefulWidget {
  @override
  __PickerDialogState createState() => __PickerDialogState();
}

class __PickerDialogState extends State<_PickerDialog> {
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_applyFilter);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LocationsModel model = Provider.of<LocationsModel>(context, listen: false);
      model.filter = '';
    });
  }

  void _applyFilter() {
    LocationsModel model = Provider.of<LocationsModel>(context, listen: false);
    model.filter = _searchController.text;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PickerAppBar(
            context,
            textEditingController: _searchController,
          ),
          body: buildList(context),
        ));
  }

  Widget buildList(BuildContext context) {
    return AppCupertinoScrollbar(
      child: Consumer<LocationsModel>(
        builder: (context, model, _) {
          return ListView(
            children: <Widget>[
              buildBestLocation(context, model),
              buildRecentLocations(context, model),
              buildAllLocations(context, model),
            ],
          );
        },
      ),
    );
  }

  Widget buildBestLocation(BuildContext context, LocationsModel model) {
    var bestLocation = model.bestLocation;
    var location = bestLocation.location;
    return StickyHeader(
      header: Category(
        asset: kAssetsLocationsBest,
        title: S.of(context).locationPickerBestTitle,
      ),
      content: InkWell(
        onTap: () => selectItemHandler(context, model, location.id),
        child: ListItem(
          asset: location.asset,
          title: location.name,
          isSelected: bestLocation.isSelected,
        ),
      ),
    );
  }

  bool selectItemHandler(
      BuildContext context, LocationsModel model, String id) {
    model.setSelected(id);
    return Navigator.of(context).pop();
  }

  Widget buildRecentLocations(BuildContext context, LocationsModel model) {
    return model.recentLocations.isNotEmpty
        ? StickyHeader(
            header: Category(
              asset: kAssetsLocationsRecent,
              title: S.of(context).locationPickerRecentTitle,
            ),
            content: Column(
              children: model.recentLocations
                  .expand((item) => convertItem(item, context, model))
                  .toList()..removeLast(),
            ),
          )
        : Container();
  }

  Widget buildAllLocations(BuildContext context, LocationsModel model) {
    return StickyHeader(
      header: Category(
        asset: kAssetsLocationsAll,
        title: S.of(context).locationPickerAllTitle,
      ),
      content: Column(
        children: model.allLocations
            .expand((item) => convertItem(item, context, model))
            .toList()..removeLast(),
      ),
    );
  }

  Padding buildSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: kSeparatorMargin, right: kSeparatorMargin),
      child: separatorHorizontal(context),
    );
  }

  List<Widget> convertItem(LocationItem item, BuildContext context, LocationsModel model) {
    return [
      InkWell(
        onTap: () => selectItemHandler(context, model, item.location.id),
        child: ListItem(
          asset: item.location.asset,
          title: item.location.name,
          isSelected: item.isSelected,
        ),
      ),
      buildSeparator(context),
    ];
  }
}
