import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/components/RFLocationComponent.dart';
import 'package:roomie_finder/models/LocationModel.dart';
import 'package:roomie_finder/views/RFSearchDetailScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFString.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFSearchFragment extends StatefulWidget {
  const RFSearchFragment({super.key});

  @override
  State createState() => _RFSearchFragmentState();
}

class _RFSearchFragmentState extends State<RFSearchFragment> {
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController residentController = TextEditingController();

  FocusNode addressFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  FocusNode residentFocusNode = FocusNode();

  List<LocationModel> locationListData = locationList();

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
      body: RFCommonAppComponent(
        title: rfAppName,
        mainWidgetHeight: 230,
        subWidgetHeight: 160,
        cardWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Advance Search', style: boldTextStyle(size: 18)),
            16.height,
            AppTextField(
              controller: addressController,
              focus: addressFocusNode,
              nextFocus: priceFocusNode,
              textFieldType: TextFieldType.EMAIL,
              decoration: rfInputDecoration(
                lableText: "Enter an address or city",
                showLableText: true,
                showPreFixIcon: true,
                prefixIcon: const Icon(Icons.location_on,
                    color: rfPrimaryColor, size: 16),
              ),
            ),
            8.height,
            AppTextField(
              controller: priceController,
              focus: priceFocusNode,
              nextFocus: residentFocusNode,
              textFieldType: TextFieldType.PHONE,
              decoration: rfInputDecoration(
                lableText: 'Enter price range',
                showLableText: true,
                showPreFixIcon: true,
                prefixIcon: const Icon(Icons.currency_rupee,
                    color: rfPrimaryColor, size: 16),
              ),
            ),
            8.height,
            AppTextField(
              controller: residentController,
              focus: residentFocusNode,
              textFieldType: TextFieldType.OTHER,
              decoration: rfInputDecoration(
                lableText: 'Resident Type',
                showLableText: true,
                showPreFixIcon: true,
                prefixIcon:
                    const Icon(Icons.menu, color: rfPrimaryColor, size: 16),
              ),
            ),
            16.height,
            AppButton(
              color: rfPrimaryColor,
              width: context.width(),
              elevation: 0,
              onTap: () {
                RFSearchDetailScreen().launch(context);
              },
              child: Text('Search Now', style: boldTextStyle(color: white)),
            ),
          ],
        ),
        subWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text('Locations', style: boldTextStyle()),
            16.height,
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                locationListData.length,
                (index) {
                  return RFLocationComponent(
                      locationData: locationListData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
