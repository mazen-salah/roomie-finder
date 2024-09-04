  
import 'package:flutter/material.dart';
import 'package:roomie_finder/screens/RFAboutUsScreen.dart';
import 'package:roomie_finder/screens/RFNotificationScreen.dart';
import 'package:roomie_finder/utils/RFImages.dart';

class SettingModel {
  final String img;
  final String roomCategoryName;
  final Widget newScreenWidget;
  
  SettingModel({
    required this.img,
    required this.roomCategoryName,
    required this.newScreenWidget,
  });
}

List<SettingModel> settingList() {
  List<SettingModel> settingListData = [];
  settingListData.add(SettingModel(
      img: rfNotification,
      roomCategoryName: "Notifications",
      newScreenWidget: RFNotificationScreen()));
  settingListData.add(SettingModel(
      img: rfAboutUs2,
      roomCategoryName: "About us",
      newScreenWidget: const RFAboutUsScreen()));
  settingListData.add(SettingModel(
      img: rfSignOut,
      roomCategoryName: "Sign Out",
      newScreenWidget: const SizedBox()));

  return settingListData;
}
