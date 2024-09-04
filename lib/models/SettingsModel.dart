import 'dart:io';

import 'package:flutter/material.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/screens/RFAboutUsScreen.dart';
import 'package:roomie_finder/screens/RFEmailSignInScreen.dart';
import 'package:roomie_finder/screens/RFNotificationScreen.dart';
import 'package:roomie_finder/utils/RFImages.dart';

class SettingModel {
  final String img;
  final String settingName;
  final Widget newScreenWidget;

  SettingModel({
    required this.img,
    required this.settingName,
    required this.newScreenWidget,
  });
}

List<SettingModel> settingList() {
  List<SettingModel> settingListData = [];
  settingListData.add(
    SettingModel(
      img: rfNotification,
      settingName: "Notifications",
      newScreenWidget: RFNotificationScreen(
        uid: userModel!.id!,
      ),
    ),
  );
  settingListData.add(
    SettingModel(
      img: rfAboutUs2,
      settingName: "About us",
      newScreenWidget: const RFAboutUsScreen(),
    ),
  );
  settingListData.add(
    SettingModel(
      img: rfSignOut,
      settingName: "Sign Out",
      newScreenWidget: const SizedBox(),
    ),
  );

  return settingListData;
}
