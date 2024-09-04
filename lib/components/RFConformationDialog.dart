// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:roomie_finder/utils/RFColors.dart';

class RFConformationDialog extends StatelessWidget {
  String message;
  RFConformationDialog({
    Key? key,
    required this.message,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: context.width(),
        height: 50.0,
        margin: EdgeInsets.only(left: 24, right: 24, top: 90),
        decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.scaffoldBackgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: boxDecorationWithRoundedCorners(
                  boxShape: BoxShape.circle,
                  backgroundColor: rf_rattingBgColor),
              child: Icon(Icons.done, color: Colors.white, size: 14),
            ),
            16.width,
            Text(message,
                style: boldTextStyle(color: greenColor.withOpacity(0.7))),
          ],
        ).onTap(() {
          //
        }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
      ),
    );
  }
}
