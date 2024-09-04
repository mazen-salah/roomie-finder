import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomFinderModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFFAQComponent extends StatelessWidget {
  final RoomFinderModel faqData;

  const RFFAQComponent({super.key, required this.faqData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: context.width(),
      margin: const EdgeInsets.only(bottom: 16),
      decoration:
          boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                backgroundColor:
                    appStore.isDarkModeOn ? scaffoldDarkColor : rfFaqBgColor,
              ),
              padding: const EdgeInsets.all(8),
              child:
                  faqData.img.validate().iconImage(iconColor: rfPrimaryColor)),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(faqData.price.validate(), style: boldTextStyle()),
              12.height,
              Text(faqData.description.validate(),
                  style: secondaryTextStyle(),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis),
            ],
          ).expand(),
        ],
      ),
    );
  }
}
