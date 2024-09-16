import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/views/RFHomeScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFImages.dart';

import '../utils/RFWidget.dart';

class RFCongratulatedDialog extends StatelessWidget {
  const RFCongratulatedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          rfCommonCachedNetworkImage(rfCongratulate,
              height: 120, width: 120, fit: BoxFit.cover),
          16.height,
          Text('Congratulations', style: boldTextStyle(size: 22)),
          8.height,
          Text('Your Request has been successfully done.',
              style: secondaryTextStyle(height: 1.5),
              textAlign: TextAlign.center),
          30.height,
          AppButton(
            color: rfPrimaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            text: "Done",
            onTap: () {
              const RFHomeScreen().launch(context).then((value) {
                finish(context);
              });
            },
            textStyle: boldTextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
