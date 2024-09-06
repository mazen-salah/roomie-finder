import 'package:flutter/material.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

import '../components/RFRecentUpdateComponent.dart';

class RFRecentUpdateViewAllScreen extends StatelessWidget {
  final List<RoomModel> hotelListData = hotelList();

  RFRecentUpdateViewAllScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: "Recent Updates",
          appBarHeight: 80,
          showLeadingIcon: false,
          roundCornerShape: true),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 24),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) =>
            RFRecentUpdateComponent(
          recentUpdateData: hotelListData[index % hotelListData.length],
        ),
      ),
    );
  }
}
