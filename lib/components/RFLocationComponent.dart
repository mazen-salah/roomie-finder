import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/models/RoomFinderModel.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFLocationComponent extends StatelessWidget {
  final RoomFinderModel locationData;
  final bool? locationWidth;

  const RFLocationComponent(
      {super.key, required this.locationData, this.locationWidth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        rfCommonCachedNetworkImage(
          locationData.img.validate(),
          fit: BoxFit.cover,
          height: 170,
          width: locationWidth.validate()
              ? context.width()
              : context.width() * 0.47 - 16,
        ),
        Container(
          height: 170,
          width: locationWidth.validate()
              ? context.width()
              : context.width() * 0.47 - 16,
          decoration: boxDecorationWithRoundedCorners(
              backgroundColor: black.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: white, size: 18),
                  8.width,
                  Text(locationData.location.validate(),
                      style: boldTextStyle(color: white)),
                ],
              ),
              4.height,
              Text(locationData.price.validate(),
                      style: secondaryTextStyle(color: white))
                  .paddingOnly(left: 4),
            ],
          ),
        ),
      ],
    );
  }
}
