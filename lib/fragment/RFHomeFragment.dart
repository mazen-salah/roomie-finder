import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/components/RFHotelListComponent.dart';
import 'package:roomie_finder/components/RFLocationComponent.dart';
import 'package:roomie_finder/components/RFRecentUpdateComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/LocationModel.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/screens/RFLocationViewAllScreen.dart';
import 'package:roomie_finder/screens/RFRecentupdateViewAllScreen.dart';
import 'package:roomie_finder/screens/RFSearchDetailScreen.dart';
import 'package:roomie_finder/screens/RFViewAllHotelListScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFString.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFHomeFragment extends StatefulWidget {
  const RFHomeFragment({super.key});

  @override
  State<RFHomeFragment> createState() => _RFHomeFragmentState();
}

class _RFHomeFragmentState extends State<RFHomeFragment> {
  List<String> categoryData = categoryList();
  List<RoomModel> hotelListData = hotelList();
  List<LocationData> locationListData = locationList();
  //List<RoomFinderModel> recentUpdateData = recentUpdateList();

  int selectCategoryIndex = 0;

  bool locationWidth = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(rfPrimaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RFCommonAppComponent(
        title: rfAppName,
        mainWidgetHeight: 200,
        subWidgetHeight: 130,
        cardWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Find a property anywhere', style: boldTextStyle(size: 18)),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.EMAIL,
              decoration: rfInputDecoration(
                hintText: "Search address or near you",
                showPreFixIcon: true,
                showLableText: false,
                prefixIcon: const Icon(Icons.location_on,
                    color: rfPrimaryColor, size: 18),
              ),
            ),
            16.height,
            AppButton(
              color: rfPrimaryColor,
              elevation: 0.0,
              width: context.width(),
              onTap: () {
                RFSearchDetailScreen().launch(context);
              },
              child: Text('Search Now', style: boldTextStyle(color: white)),
            ),
            TextButton(
              onPressed: () {
                //
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Text('Advance Search',
                    style: primaryTextStyle(), textAlign: TextAlign.end),
              ),
            )
          ],
        ),
        subWidget: Column(
          children: [
            HorizontalList(
              padding: const EdgeInsets.only(right: 16, left: 16),
              wrapAlignment: WrapAlignment.spaceEvenly,
              itemCount: categoryData.length,
              itemBuilder: (BuildContext context, int index) {
                String data = categoryData[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: appStore.isDarkModeOn
                          ? scaffoldDarkColor
                          : selectCategoryIndex == index
                              ? rfSelectedCategoryBgColor
                              : rfCategoryBgColor,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      data.validate(),
                      style: boldTextStyle(
                          color: selectCategoryIndex == index
                              ? rfPrimaryColor
                              : gray),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recently Added Properties', style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFViewAllHotelListScreen().launch(context);
                  },
                  child: Text('View All',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline,
                          textBaseline: TextBaseline.alphabetic)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: hotelListData.take(3).length,
              itemBuilder: (BuildContext context, int index) {
                RoomModel data = hotelListData[index];
                return RFHotelListComponent(hotelData: data);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Locations', style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFLocationViewAllScreen(locationWidth: true)
                        .launch(context);
                  },
                  child: Text('View All',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(locationListData.length, (index) {
                return RFLocationComponent(
                    locationData: locationListData[index]);
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Updates', style: boldTextStyle()),
                TextButton(
                  onPressed: () {
                    RFRecentUpdateViewAllScreen().launch(context);
                  },
                  child: Text('See All',
                      style: secondaryTextStyle(
                          decoration: TextDecoration.underline)),
                )
              ],
            ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: hotelListData.take(3).length,
              itemBuilder: (BuildContext context, int index) {
                RoomModel data = hotelListData[index];
                return RFRecentUpdateComponent(recentUpdateData: data);
              },
            ),
          ],
        ),
      ),
    );
  }
}
