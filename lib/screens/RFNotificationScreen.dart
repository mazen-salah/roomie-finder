import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFNotificationListComponent.dart';
import 'package:roomie_finder/models/NotficationModel.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFNotificationScreen extends StatelessWidget {
  final String uid;

  const RFNotificationScreen({super.key, required this.uid});

  Future<List<NotificationModel>> fetchNotifications() async {
    List<NotificationModel> notifications = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .get();
        
    for (var doc in querySnapshot.docs) {
      notifications
          .add(NotificationModel.fromMap(doc.data() as Map<String, dynamic>));
    }
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        showLeadingIcon: false,
        title: 'Notifications',
        roundCornerShape: true,
        appBarHeight: 80,
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications available'));
          } else {
            List<NotificationModel> notificationData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('All', style: boldTextStyle(size: 18)),
                      TextButton(
                          onPressed: () {},
                          child: Text('Mark all read',
                              style: secondaryTextStyle())),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 16),
                  ListView.builder(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, bottom: 4),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notificationData.length,
                    itemBuilder: (BuildContext context, int index) {
                      NotificationModel data = notificationData[index];
                      return RFNotificationListComponent(
                        readNotification: data.unReadNotification,
                        title: data.title,
                        subTitle: data.description,
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
