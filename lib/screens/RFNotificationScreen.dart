import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFNotificationListComponent.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFNotificationScreen extends StatelessWidget {
  final List<NotificationModel> notificationData = notificationList();
  

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
                NotificationModel data = notificationData[index];
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
