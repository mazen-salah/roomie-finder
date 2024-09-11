import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/views/RFHotelDescriptionScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFHotelListComponent extends StatelessWidget {
  final RoomModel? hotelData;
  final bool? showHeight;

  const RFHotelListComponent({super.key, this.hotelData, this.showHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration:
          boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rfCommonCachedNetworkImage(hotelData!.img.validate(),
                  height: 100, width: 100, fit: BoxFit.cover)
              .cornerRadiusWithClipRRect(8),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hotelData!.name.validate(), style: boldTextStyle()),
                      8.height,
                      Row(
                        children: [
                          Text("${hotelData!.price.validate()} SAR",
                              style: boldTextStyle(color: rfPrimaryColor)),
                          4.width,
                          Text(hotelData!.rentDuration.validate(),
                              style: secondaryTextStyle()),
                        ],
                      ).fit(),
                    ],
                  ).expand(),
                  Row(
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          // backgroundColor: hotelData!.color ?? greenColor,
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                      6.width,
                      Text(hotelData!.address.validate(),
                          style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ).paddingOnly(left: 3),
              showHeight.validate() ? 8.height : 24.height,
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: rfPrimaryColor, size: 16),
                  6.width,
                  Text(hotelData!.location.validate(),
                      style: secondaryTextStyle()),
                ],
              ),
            ],
          ).expand()
        ],
      ),
    ).onTap(() {
      RFHotelDescriptionScreen(hotelData: hotelData,).launch(context);
    },
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent);
  }
}
