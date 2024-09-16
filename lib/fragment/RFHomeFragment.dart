import 'package:flutter/material.dart';
import 'package:roomie_finder/controllers/rf_home_controller.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/models/LocationModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/components/RFHotelListComponent.dart';
import 'package:roomie_finder/components/RFLocationComponent.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import 'package:roomie_finder/views/Home/RFAddProperty.dart';
import 'package:roomie_finder/views/RFSearchDetailScreen.dart';

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

  Future<void> _addNewProperty() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddPropertyDialog();
      },
    );

    if (result == true) {
      // Assuming that the dialog returns true if a new property was added
      setState(() {
        isLoading = true;
      });
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: userModel!.role == "lessor"
          ? FloatingActionButton(
              onPressed: _addNewProperty,
              backgroundColor: rfPrimaryColor,
              child: const Icon(Icons.add),
            )
          : null,
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
    TextEditingController searchController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Find a property anywhere', style: boldTextStyle(size: 18)),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.OTHER,
          controller: searchController,
          decoration: rfInputDecoration(
            hintText: "Search property",
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
            RFSearchDetailScreen(
              searchQuery: searchController.text,
            ).launch(context);
          },
          child: Text('Search Now', style: boldTextStyle(color: white)),
        ),
      ],
    );
  }

  Column buildPropertyAndLocationSection(BuildContext context) {
    return Column(
      children: [
        buildSectionHeader('All Properties', () {
          // Navigate to view all
        }),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hotelListData.length,
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
      ],
    ).paddingOnly(left: 16, right: 16, top: 16, bottom: 8);
  }
}
