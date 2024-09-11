import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/views/RFHotelDescriptionScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFRecentUpdateComponent extends StatelessWidget {
  final RoomModel recentUpdateData;

  const RFRecentUpdateComponent({super.key, required this.recentUpdateData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          rfCommonCachedNetworkImage(recentUpdateData.img.validate(),
              width: context.width(), height: 150, fit: BoxFit.cover),
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(recentUpdateData.name.validate(), style: boldTextStyle())
                  .paddingOnly(left: 4),
              Row(
                children: [
                  Text(recentUpdateData.price.validate(),
                      style: boldTextStyle(color: rfPrimaryColor)),
                  Text(recentUpdateData.rentDuration.validate(),
                      style: secondaryTextStyle()),
                ],
              ),
            ],
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: rfPrimaryColor, size: 16),
                  8.width,
                  Text(recentUpdateData.location.validate(),
                      style: secondaryTextStyle()),
                ],
              ),
              Row(
                children: [
                  Text(recentUpdateData.description.validate(),
                      style: secondaryTextStyle()),
                  Text(recentUpdateData.reviews.toString().validate(),
                      style: secondaryTextStyle()),
                ],
              ),
            ],
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              2.width,
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  boxShape: BoxShape.circle,
                  // backgroundColor: recentUpdateData.color ?? greenColor,
                ),
                padding: const EdgeInsets.all(4),
              ),
              11.width,
              Text(recentUpdateData.address.validate(),
                  style: secondaryTextStyle()),
            ],
          ).paddingOnly(left: 2),
        ],
      ),
    ).onTap(() {
      RFHotelDescriptionScreen(hotelData: recentUpdateData).launch(context);
    },
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent);
  }
}
