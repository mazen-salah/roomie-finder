import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import 'package:roomie_finder/models/RoomModel.dart';

class RFAppliedHotelListComponent extends StatelessWidget {
  final RoomModel appliedHotelList;

  const RFAppliedHotelListComponent(
      {super.key, required this.appliedHotelList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Add rounded corners
            child: rfCommonCachedNetworkImage(
              appliedHotelList.img.validate(),
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: rfPrimaryColor),
                    child: Text(appliedHotelList.price.validate(),
                        style: boldTextStyle(color: white, size: 14)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: rfRattingBgColor),
                    child: Row(
                      children: [
                        Text(appliedHotelList.views.toString().validate(),
                            style: boldTextStyle(color: white, size: 14)),
                        4.width,
                        const Icon(Icons.star, color: white, size: 14),
                      ],
                    ),
                  )
                ],
              ),
              16.height,
              Text(appliedHotelList.roomCategoryName.validate(),
                  style: boldTextStyle(size: 18)),
              4.height,
              Text(appliedHotelList.location.validate(),
                  style: primaryTextStyle()),
              16.height,
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: rfPrimaryColor, size: 16),
                      6.width,
                      Text(appliedHotelList.rentDuration.validate(),
                              style: secondaryTextStyle())
                          .flexible(),
                    ],
                  ).expand(),
                  16.width,
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: redColor),
                      ),
                      4.width,
                      Text(appliedHotelList.address.validate(),
                          style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ),
            ],
          ).expand()
        ],
      ),
    );
  }
}
