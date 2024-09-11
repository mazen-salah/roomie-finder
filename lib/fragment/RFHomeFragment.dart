import 'package:flutter/material.dart';
import 'package:roomie_finder/controllers/rf_home_controller.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/models/LocationModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/components/RFHotelListComponent.dart';
import 'package:roomie_finder/components/RFLocationComponent.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import 'package:roomie_finder/views/RFAddProperty.dart';

class RFHomeFragment extends StatefulWidget {
  const RFHomeFragment({super.key});

  @override
  State<RFHomeFragment> createState() => _RFHomeFragmentState();
}

class _RFHomeFragmentState extends State<RFHomeFragment> {
  RFHomeController controller = RFHomeController();
  List<String> categoryData = [];
  List<RoomModel> hotelListData = [];
  List<LocationModel> locationListData = [];
  int selectCategoryIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(rfPrimaryColor,
        statusBarIconBrightness: Brightness.light);
    hotelListData = await controller.fetchRoomData();
    locationListData = await controller.fetchLocationData();
    setState(() {
      isLoading = false;
    });
  }

  void _addNewProperty() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddPropertyDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProperty,
        backgroundColor: rfPrimaryColor,
        child: const Icon(Icons.add),
      ),
      body: RFCommonAppComponent(
        title: 'RoomieFinder',
        mainWidgetHeight: 200,
        subWidgetHeight: 130,
        cardWidget: buildSearchSection(context),
        subWidget: isLoading
            ? const Center(child: CircularProgressIndicator())
            : buildPropertyAndLocationSection(context),
      ),
    );
  }

  Column buildSearchSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Find a property anywhere', style: boldTextStyle(size: 18)),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.EMAIL,
          decoration: rfInputDecoration(
            hintText: "Search address or near you",
            showPreFixIcon: true,
            showLableText: false,
            prefixIcon:
                const Icon(Icons.location_on, color: rfPrimaryColor, size: 18),
          ),
        ),
        16.height,
        AppButton(
          color: rfPrimaryColor,
          elevation: 0.0,
          width: context.width(),
          onTap: () {
            // Navigate to search
          },
          child: Text('Search Now', style: boldTextStyle(color: white)),
        ),
      ],
    );
  }

  Column buildPropertyAndLocationSection(BuildContext context) {
    return Column(
      children: [
        HorizontalList(
          padding: const EdgeInsets.only(right: 16, left: 16),
          itemCount: categoryData.length,
          itemBuilder: (BuildContext context, int index) {
            String data = categoryData[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectCategoryIndex = index;
                });
              },
              child: buildCategoryCard(data, index),
            );
          },
        ),
        buildSectionHeader('Recently Added Properties', () {
          // Navigate to view all
        }),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hotelListData.take(3).length,
          itemBuilder: (BuildContext context, int index) {
            return RFHotelListComponent(hotelData: hotelListData[index]);
          },
        ),
        buildSectionHeader('Locations', () {
          // Navigate to view all
        }),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(locationListData.length, (index) {
            return RFLocationComponent(locationData: locationListData[index]);
          }),
        ),
      ],
    );
  }

  Padding buildSectionHeader(String title, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: boldTextStyle()),
        TextButton(
          onPressed: onPressed,
          child: Text('View All',
              style: secondaryTextStyle(decoration: TextDecoration.underline)),
        )
      ],
    ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8);
  }

  Container buildCategoryCard(String data, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: selectCategoryIndex == index
            ? rfSelectedCategoryBgColor
            : rfCategoryBgColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(data.validate(),
          style: boldTextStyle(
              color: selectCategoryIndex == index ? rfPrimaryColor : gray)),
    );
  }
}
