import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFNotificationListComponent extends StatelessWidget {
  final bool? readNotification;
  final String? title;
  final String? subTitle;

  const RFNotificationListComponent(
      {super.key, this.readNotification, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        border: Border.all(
            color: readNotification.validate()
                ? gray.withOpacity(0.3)
                : rfSplashBgColor.withOpacity(0.2)),
        backgroundColor: context.cardColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: appStore.isDarkModeOn
                  ? scaffoldDarkColor
                  : rfNotificationBgColor,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Stack(
              children: [
                rfNotification.iconImage(
                    iconColor: appStore.isDarkModeOn ? white : black),
                Positioned(
                  top: 1,
                  right: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                      backgroundColor: readNotification.validate()
                          ? redColor
                          : Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
          ),
          16.width,
          rfCommonRichText(
            title: title.validate(),
            subTitle: subTitle.validate(),
            titleTextStyle: primaryTextStyle(),
            subTitleTextStyle: boldTextStyle(),
          ).flexible()
        ],
      ),
    );
  }
}
