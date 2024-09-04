import 'package:flutter/material.dart';
import 'package:roomie_finder/components/RFHotelListComponent.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFViewAllHotelListScreen extends StatelessWidget {
  final List<RoomModel> hotelListData = hotelList();

  RFViewAllHotelListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: "Recently Added Properties",
          appBarHeight: 80,
          showLeadingIcon: false,
          roundCornerShape: true),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 24),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          RoomModel data = hotelListData[index % hotelListData.length];
          return RFHotelListComponent(hotelData: data);
        },
      ),
    );
  }
}
