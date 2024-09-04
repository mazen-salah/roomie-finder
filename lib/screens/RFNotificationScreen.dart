import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFNotificationListComponent.dart';
import 'package:roomie_finder/models/RoomFinderModel.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFNotificationScreen extends StatelessWidget {
  final List<RoomFinderModel> notificationData = notificationList();
  final List<RoomFinderModel> yesterdayNotificationData =
      yesterdayNotificationList();
  final bool yesterdayList = true;

  RFNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          showLeadingIcon: false,
          title: 'Notifications',
          roundCornerShape: true,
          appBarHeight: 80),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today', style: boldTextStyle(size: 18)),
                TextButton(
                    onPressed: () {},
                    child: Text('Mark all read', style: secondaryTextStyle())),
              ],
            ).paddingOnly(left: 16, right: 16, top: 16),
            ListView.builder(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 4),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notificationData.length,
              itemBuilder: (BuildContext context, int index) {
                RoomFinderModel data = notificationData[index];
                return RFNotificationListComponent(
                  readNotification: data.unReadNotification.validate(),
                  title: data.price.validate(),
                  subTitle: data.description.validate(),
                );
              },
            ),
            Text('Yesterday', style: boldTextStyle(size: 18))
                .paddingOnly(left: 16),
            ListView.builder(
              padding:
                  const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: yesterdayNotificationData.length,
              itemBuilder: (BuildContext context, int index) {
                RoomFinderModel data = yesterdayNotificationData[index];
                return RFNotificationListComponent(
                  readNotification: data.unReadNotification.validate(),
                  title: data.price.validate(),
                  subTitle: data.description.validate(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
