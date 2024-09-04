import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFAppliedHotelListComponent.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomFinderModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFAccountFragment extends StatefulWidget {
  const RFAccountFragment({super.key});

  @override
  State<RFAccountFragment> createState() => _RFAccountFragmentState();
}

class _RFAccountFragmentState extends State<RFAccountFragment> {
  final List<RoomFinderModel> settingData = settingList();
  final List<RoomFinderModel> appliedHotelData = appliedHotelList();
  final List<RoomFinderModel> applyHotelData = applyHotelList();

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RFCommonAppComponent(
        title: "Account",
        mainWidgetHeight: 200,
        subWidgetHeight: 100,
        accountCircleWidget: Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 150),
                width: 100,
                height: 100,
                decoration: boxDecorationWithRoundedCorners(
                    boxShape: BoxShape.circle,
                    border: Border.all(color: white, width: 4)),
                child: rfCommonCachedNetworkImage(userModel!.profileImageUrl,
                    fit: BoxFit.cover, width: 100, height: 100, radius: 150),
              ),
              Positioned(
                bottom: 8,
                right: -4,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(6),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    boxShape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0.4,
                          blurRadius: 3,
                          color: gray.withOpacity(0.1),
                          offset: const Offset(1, 6)),
                    ],
                  ),
                  child: Icon(Icons.add,
                      color: appStore.isDarkModeOn ? white : rfPrimaryColor,
                      size: 16),
                ),
              ),
            ],
          ),
        ),
        subWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text(userModel!.fullName.validate(), style: boldTextStyle(size: 18))
                .center(),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('10 Applied', style: secondaryTextStyle()),
                8.width,
                Container(
                    height: 10,
                    width: 1,
                    color:
                        appStore.isDarkModeOn ? white : gray.withOpacity(0.4)),
                8.width,
                Text(userModel!.location, style: secondaryTextStyle()),
              ],
            ),
            32.height,
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    launchCall(userModel!.phone);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: context.scaffoldBackgroundColor,
                    side: BorderSide(color: context.dividerColor, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rfCall.iconImage(
                          iconColor:
                              appStore.isDarkModeOn ? white : rfPrimaryColor),
                      8.width,
                      Text('Call Me',
                          style: boldTextStyle(
                              color: appStore.isDarkModeOn
                                  ? white
                                  : rfPrimaryColor)),
                    ],
                  ),
                ).expand(),
                16.width,
                AppButton(
                  color: rfPrimaryColor,
                  elevation: 0.0,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  width: context.width(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      rfMessage.iconImage(iconColor: whiteColor),
                      // rfCommonCachedNetworkImage(rf_message, color: white, height: 16, width: 16),
                      8.width,
                      Text('Message Me', style: boldTextStyle(color: white)),
                    ],
                  ),
                  onTap: () {
                    launchMail(userModel!.email);
                  },
                ).expand()
              ],
            ).paddingSymmetric(horizontal: 16),
            Container(
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(
                    color: appStore.isDarkModeOn
                        ? gray.withOpacity(0.3)
                        : rfSelectedCategoryBgColor),
                backgroundColor: context.cardColor,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Email', style: boldTextStyle()),
                      Text(userModel!.email, style: secondaryTextStyle()),
                    ],
                  ).paddingSymmetric(horizontal: 24, vertical: 16),
                  Divider(color: context.dividerColor, height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Location', style: boldTextStyle()),
                      Text("${userModel!.location}, Saudi Arabia",
                       style: secondaryTextStyle()),
                    ],
                  ).paddingSymmetric(horizontal: 24, vertical: 16),
                  Divider(color: context.dividerColor, height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone No', style: boldTextStyle()),
                      Text('(+977) ${userModel!.phone}', style: secondaryTextStyle()),
                    ],
                  ).paddingSymmetric(horizontal: 24, vertical: 16),
                ],
              ),
            ),
            16.height,
            HorizontalList(
              itemCount: applyHotelData.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (_, index) {
                RoomFinderModel data = applyHotelData[index];

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: selectedIndex == index
                        ? rfSelectedCategoryBgColor
                        : Colors.transparent,
                  ),
                  child: Text(
                    data.roomCategoryName.validate(),
                    style: boldTextStyle(
                        color: selectedIndex == index
                            ? rfPrimaryColor
                            : gray.withOpacity(0.4)),
                  ),
                ).onTap(() {
                  selectedIndex = index;
                  setState(() {});
                },
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent);
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: appliedHotelData.length,
              itemBuilder: (BuildContext context, int index) {
                RoomFinderModel data = appliedHotelData[index];
                return RFAppliedHotelListComponent(appliedHotelList: data);
              },
            ),
          ],
        ),
      ),
    );
  }
}
