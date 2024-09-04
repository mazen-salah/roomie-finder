import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFAboutUsScreen extends StatelessWidget {
  const RFAboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          showLeadingIcon: false,
          title: 'About Us',
          roundCornerShape: true,
          appBarHeight: 80),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            rfCommonCachedNetworkImage(rfAboutUs,
                fit: BoxFit.cover, height: 150, width: context.width()),
            Container(
              decoration: boxDecorationRoundedWithShadow(8,
                  backgroundColor: context.cardColor),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About RoomieFinder', style: boldTextStyle()),
                  8.height,
                  Text(
                      'RoomieFinder is your go-to platform for finding the perfect house and housemates. Our app uses advanced AI technology to match you with compatible living spaces and like-minded roommates, making your rental experience smoother and more enjoyable.',
                      style: secondaryTextStyle()),
                  16.height,
                  Text('Our Team', style: boldTextStyle()),
                  8.height,
                  Text(
                    'We are a group of passionate developers, designers, and real estate enthusiasts dedicated to revolutionizing the rental market. With a focus on innovation and user experience, we strive to make finding your next home a hassle-free process.',
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
