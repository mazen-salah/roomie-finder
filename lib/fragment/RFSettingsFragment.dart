import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomFinderModel.dart';
import 'package:roomie_finder/screens/RFEmailSignInScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFSettingsFragment extends StatefulWidget {
  @override
  State<RFSettingsFragment> createState() => _RFSettingsFragmentState();
}

class _RFSettingsFragmentState extends State<RFSettingsFragment> {
  final List<RoomFinderModel> settingData = settingList();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(rf_primaryColor,
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
                margin: EdgeInsets.only(top: 150),
                width: 100,
                height: 100,
                decoration: boxDecorationWithRoundedCorners(
                    boxShape: BoxShape.circle,
                    border: Border.all(color: white, width: 4)),
                child: rfCommonCachedNetworkImage(rf_user,
                    fit: BoxFit.cover, width: 100, height: 100, radius: 150),
              ),
              Positioned(
                bottom: 8,
                right: -4,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(6),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    boxShape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0.4,
                          blurRadius: 3,
                          color: gray.withOpacity(0.1),
                          offset: Offset(1, 6)),
                    ],
                  ),
                  child: Icon(Icons.add,
                      color: appStore.isDarkModeOn ? white : rf_primaryColor,
                      size: 16),
                ),
              ),
            ],
          ),
        ),
        subWidget: Column(
          children: [
            16.height,
            Text('Courtney Henry', style: boldTextStyle(size: 18)),
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
                Text('Kathmandu', style: secondaryTextStyle()),
              ],
            ),
            16.height,
            Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: appStore.isDarkModeOn
                    ? scaffoldDarkColor
                    : rf_selectedCategoryBgColor,
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rf_person
                      .iconImage(iconColor: rf_primaryColor)
                      .paddingOnly(top: 4),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Edit Profile",
                          style: boldTextStyle(color: rf_primaryColor)),
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
            SettingItemWidget(
              title: "Dark Mode",
              leading: Icon(Icons.dark_mode_outlined,
                  size: 18, color: rf_primaryColor),
              titleTextStyle: primaryTextStyle(),
              trailing: Switch(
                value: appStore.isDarkModeOn,
                activeTrackColor: rf_primaryColor,
                onChanged: (bool value) {
                  appStore.toggleDarkMode(value: value);
                  setStatusBarColor(rf_primaryColor,
                      statusBarIconBrightness: Brightness.light);
                  setState(() {});
                },
              ),
              padding: EdgeInsets.only(left: 40, right: 16, top: 8),
              onTap: () {
                //
              },
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: 22),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: settingData.length,
              itemBuilder: (BuildContext context, int index) {
                RoomFinderModel data = settingData[index];
                return Container(
                  margin: EdgeInsets.only(right: 24),
                  child: SettingItemWidget(
                    title: data.roomCategoryName.validate(),
                    leading: data.img
                        .validate()
                        .iconImage(iconColor: rf_primaryColor, size: 18),
                    titleTextStyle: primaryTextStyle(),
                    onTap: () {
                      if (index == 4) {
                        showConfirmDialogCustom(
                          context,
                          cancelable: false,
                          title: "Are you sure you want to logout?",
                          dialogType: DialogType.CONFIRMATION,
                          onCancel: (v) {
                            finish(context);
                          },
                          onAccept: (v) {
                            RFEmailSignInScreen().launch(v).then((value) {
                              finish(context);
                            });
                          },
                        );
                      } else {
                        data.newScreenWidget.validate().launch(context);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
