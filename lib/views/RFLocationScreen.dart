import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFHotelListComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFLocationScreen extends StatefulWidget {
  const RFLocationScreen({super.key});

  @override
  State<RFLocationScreen> createState() => _RFLocationScreenState();
}

class _RFLocationScreenState extends State<RFLocationScreen> {
  TextEditingController addressController = TextEditingController();

  List<RoomModel> hotelListData = hotelList();
  List<String> availableHotelListData = availableHotelList();

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          showLeadingIcon: false,
          appBarHeight: 50,
          title: "Search Detail",
          roundCornerShape: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 24, bottom: 32),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
                backgroundColor: rfPrimaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Search for Property",
                      style: boldTextStyle(color: white)),
                  16.height,
                  AppTextField(
                    controller: addressController,
                    textFieldType: TextFieldType.OTHER,
                    decoration: rfInputDecoration(
                      showLableText: false,
                      showPreFixIcon: true,
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search,
                              color: rfPrimaryColor, size: 16),
                          8.width,
                          Text('Imadol', style: boldTextStyle()),
                          8.width,
                          Container(
                              width: 1,
                              height: 15,
                              color: appStore.isDarkModeOn
                                  ? white
                                  : gray.withOpacity(0.6)),
                          16.width,
                        ],
                      ).paddingOnly(left: 16),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Showing Results', style: boldTextStyle()),
                Text('4 Results', style: secondaryTextStyle()),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 16),
            HorizontalList(
              itemCount: availableHotelListData.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (_, index) {
                String data = availableHotelListData[index];

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: selectedIndex == index
                        ? gray.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Text(
                    data.validate(),
                    style: boldTextStyle(
                        color: selectedIndex == index
                            ? appStore.isDarkModeOn
                                ? white
                                : black
                            : appStore.isDarkModeOn
                                ? white.withOpacity(0.4)
                                : gray.withOpacity(0.6)),
                  ),
                ).onTap(() {
                  selectedIndex = index;
                  setState(() {});
                });
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: hotelListData.length,
              itemBuilder: (BuildContext context, int index) =>
                  RFHotelListComponent(hotelData: hotelListData[index]),
            ),
          ],
        ),
      ),
    );
  }
}