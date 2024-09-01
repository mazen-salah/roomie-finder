import 'package:flutter/material.dart';
import 'package:roomie_finder/components/RFHotelListComponent.dart';
import 'package:roomie_finder/models/RoomFinderModel.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFViewAllHotelListScreen extends StatelessWidget {
  final List<RoomFinderModel> hotelListData = hotelList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: "Recently Added Properties",
          appBarHeight: 80,
          showLeadingIcon: false,
          roundCornerShape: true),
      body: ListView.builder(
        padding: EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 24),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          RoomFinderModel data = hotelListData[index % hotelListData.length];
          return RFHotelListComponent(hotelData: data);
        },
      ),
    );
  }
}
