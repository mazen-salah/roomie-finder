import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomie_finder/components/RFRecentUpdateComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/views/RFLocationScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFSearchDetailScreen extends StatelessWidget {
  String searchQuery;

  RFSearchDetailScreen({super.key, this.searchQuery = ''});

  Future<List<RoomModel>> _fetchRooms() async {
    final firestore = FirebaseFirestore.instance;
    final query = firestore
        .collection('rooms')
        .where('name', isGreaterThanOrEqualTo: searchQuery)
        .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
        .limit(3);

    // Extend the query for other fields
    final results = await query.get();
    return results.docs.map((doc) {
      final data = doc.data();
      return RoomModel(
        address: data['address'],
        description: data['description'],
        img: data['img'],
        location: data['location'],
        name: data['name'],
        owner: data['owner'],
        price: data['price'],
        rentDuration: data['rentDuration'],
        reviews: data['reviews'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController =
        TextEditingController(text: searchQuery);

    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        showLeadingIcon: false,
        appBarHeight: 50,
        title: "Search Detail",
        roundCornerShape: false,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    onFieldSubmitted: (v) {
                      const RFLocationScreen().launch(context);
                    },
                  )
                ],
              ),
            ),
            if (searchQuery.isNotEmpty)
              FutureBuilder<List<RoomModel>>(
                future: _fetchRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: const Text('No results found.'));
                  }

                  final rooms = snapshot.data!;
                  return Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Showing Results', style: boldTextStyle()),
                          Text('${rooms.length} Results',
                              style: secondaryTextStyle()),
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 16),
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: rooms.length,
                        itemBuilder: (BuildContext context, int index) =>
                            RFRecentUpdateComponent(
                                recentUpdateData: rooms[index]),
                      ),
                    ],
                  );
                },
              ),
            if (searchQuery.isEmpty)
              Center(
                child: Text('Search for properties', style: boldTextStyle()),
              ),
          ],
        ),
      ),
    );
  }
}
