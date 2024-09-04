class NotificationModel {
  final String title;
  final bool unReadNotification;
  final String description;

  NotificationModel({
    required this.title,
    required this.unReadNotification,
    required this.description,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      unReadNotification: map['unReadNotification'] as bool,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'unReadNotification': unReadNotification,
      'description': description,
    };
  }
}

List<NotificationModel> notificationList() {
  List<NotificationModel> notificationListData = [];
  notificationListData.add(NotificationModel(
      title: "Welcome",
      unReadNotification: false,
      description: "Don’t forget to complete your personal info."));
  notificationListData.add(NotificationModel(
      title: "There are 4 available properties, you recently selected. ",
      unReadNotification: true,
      description: "Click here for more details."));

  return notificationListData;
}
