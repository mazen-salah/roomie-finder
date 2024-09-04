import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFPremiumServiceComponent extends StatelessWidget {
  const RFPremiumServiceComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rfAboutUs2.iconImage(iconColor: rfPrimaryColor).paddingOnly(top: 4),
        16.width,
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Get ready to get Featured?", style: secondaryTextStyle()),
                8.height,
                Text("Go for Premium Service", style: boldTextStyle()),
              ],
            ),
            16.width,
            AppButton(
              color: rfPrimaryColor,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child:
                  Text('Upgrade', style: boldTextStyle(color: white, size: 14)),
              onTap: () {
                //
              },
            ).expand()
          ],
        ).expand(),
      ],
    );
  }
}
