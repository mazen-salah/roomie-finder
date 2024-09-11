import 'package:flutter/material.dart';
import 'package:roomie_finder/components/RFLocationComponent.dart';
import 'package:roomie_finder/models/LocationModel.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFLocationViewAllScreen extends StatelessWidget {
  final List<LocationModel> locationListData = locationList();
  final bool? locationWidth;

  RFLocationViewAllScreen({super.key, this.locationWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: "Locations",
          appBarHeight: 80,
          showLeadingIcon: false,
          roundCornerShape: true),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
        child: Wrap(
          spacing: 8,
          runSpacing: 16,
          children: List.generate(
            20,
            (index) {
              return RFLocationComponent(
                  locationData:
                      locationListData[index % locationListData.length],
                  locationWidth: locationWidth);
            },
          ),
        ),
      ),
    );
  }
}
