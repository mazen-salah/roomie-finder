import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/SettingsModel.dart';
import 'package:roomie_finder/screens/RFEmailSignInScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFSettingsFragment extends StatefulWidget {
  const RFSettingsFragment({super.key});

  @override
  State<RFSettingsFragment> createState() => _RFSettingsFragmentState();
}

class _RFSettingsFragmentState extends State<RFSettingsFragment> {
  final List<SettingModel> settingData = settingList();

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
        title: "Settings",
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
                child: rfCommonCachedNetworkImage(
                    userModel?.profileImageUrl ??
                        'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    radius: 150),
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
          children: [
            16.height,
            Text(userModel!.fullName, style: boldTextStyle(size: 18)),
            8.height,
            Text('${userModel!.location}, Saudi Arabia',
                    style: secondaryTextStyle())
                .center(),
            SettingItemWidget(
              title: "Dark Mode",
              leading: const Icon(Icons.dark_mode_outlined,
                  size: 18, color: rfPrimaryColor),
              titleTextStyle: primaryTextStyle(),
              trailing: Switch(
                value: appStore.isDarkModeOn,
                activeTrackColor: rfPrimaryColor,
                onChanged: (bool value) {
                  appStore.toggleDarkMode(value: value);
                  setStatusBarColor(rfPrimaryColor,
                      statusBarIconBrightness: Brightness.light);
                  setState(() {});
                },
              ),
              padding: const EdgeInsets.only(left: 40, right: 16, top: 8),
              onTap: () {
                //
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.only(left: 22),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: settingData.length,
              itemBuilder: (BuildContext context, int index) {
                SettingModel data = settingData[index];
                return Container(
                  margin: const EdgeInsets.only(right: 24),
                  child: SettingItemWidget(
                    title: data.settingName.validate(),
                    leading: data.img
                        .validate()
                        .iconImage(iconColor: rfPrimaryColor, size: 18),
                    titleTextStyle: primaryTextStyle(),
                    onTap: () {
                      if (data.settingName == "Sign Out") {
                        showConfirmDialogCustom(
                          context,
                          cancelable: false,
                          title: "Are you sure you want to logout?",
                          primaryColor: rfPrimaryColor,
                          dialogType: DialogType.CONFIRMATION,
                          onCancel: (v) {
                            finish(context);
                          },
                          onAccept: (v) {
                            RFAuthController().signOut();
                            const RFEmailSignInScreen()
                                .launch(context, isNewTask: true);
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
