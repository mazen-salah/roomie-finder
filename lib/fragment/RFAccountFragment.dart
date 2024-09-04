import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomie_finder/components/RFAppliedHotelListComponent.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/screens/RFEditProfileScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFAccountFragment extends StatefulWidget {
  const RFAccountFragment({super.key});

  @override
  State<RFAccountFragment> createState() => _RFAccountFragmentState();
}

class _RFAccountFragmentState extends State<RFAccountFragment> {
  List<RoomModel> appliedHotelData = [];
  List<RoomModel> likedHotelData = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await fetchUserAppliedHotels();
    await fetchUserLikedHotels();
  }

  Future<void> fetchUserAppliedHotels() async {
    try {
      final uid = userModel!.id;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('applied')
          .where('uid', isEqualTo: uid)
          .get();

      setState(() {
        appliedHotelData = querySnapshot.docs
            .map((doc) => RoomModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      log('Error fetching applied hotels: $e');
    }
  }

  Future<void> fetchUserLikedHotels() async {
    try {
      final uid = userModel!.id;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('liked')
          .where('uid', isEqualTo: uid)
          .get();

      setState(() {
        likedHotelData = querySnapshot.docs
            .map((doc) => RoomModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      log('Error fetching liked hotels: $e');
    }
  }

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
            Text("${userModel!.location}, Saudi Arabia",
                    style: secondaryTextStyle())
                .center(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: appStore.isDarkModeOn
                    ? scaffoldDarkColor
                    : rfSelectedCategoryBgColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rfPerson
                      .iconImage(iconColor: rfPrimaryColor)
                      .paddingOnly(top: 4),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Edit Profile",
                              style: boldTextStyle(color: rfPrimaryColor))
                          .onTap(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      }),
                      8.height,
                      Text(
                        "Edit all the basic profile information associated with your profile",
                        style: secondaryTextStyle(color: gray),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ).expand(),
                ],
              ),
            ),
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
                      Text('(+977) ${userModel!.phone}',
                          style: secondaryTextStyle()),
                    ],
                  ).paddingSymmetric(horizontal: 24, vertical: 16),
                ],
              ),
            ),
            16.height,
            HorizontalList(
              itemCount: likedHotelData.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (_, index) {
                RoomModel data = likedHotelData[index];
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
                RoomModel data = appliedHotelData[index];
                return RFAppliedHotelListComponent(appliedHotelList: data);
              },
            ),
          ],
        ),
      ),
    );
  }
}
