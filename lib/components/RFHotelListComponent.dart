import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/views/RFHotelDescriptionScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RFHotelListComponent extends StatefulWidget {
  final RoomModel? hotelData;
  final bool? showHeight;

  const RFHotelListComponent({super.key, this.hotelData, this.showHeight});

  @override
  _RFHotelListComponentState createState() => _RFHotelListComponentState();
}

class _RFHotelListComponentState extends State<RFHotelListComponent> {
  double? compatibilityPercentage;
  String? compatibilityMessage;

  @override
  void initState() {
    super.initState();
    fetchCompatibility(); // Fetch the compatibility percentage when the widget is built
  }

  Future<void> fetchCompatibility() async {
    try {
      String roomId = widget.hotelData!.id.validate();
      String? userId = userModel!.id;

      // Call your function to get the compatibility percentage
      double percentage = await getCompatibilityPercentage(roomId, userId!);
      setState(() {
        if (percentage == -1) {
          compatibilityMessage = "You are the only resident";
        } else if (percentage == -2) {
          compatibilityMessage = "The property is empty";
        } else {
          compatibilityPercentage = percentage;
        }
      });
    } catch (e) {
      log('Error fetching compatibility: $e');
    }
  }

  Future<double> getCompatibilityPercentage(String roomId, String userId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot userDoc = await db.collection('questionnaires').doc(userId).get();
    List<String> roommates = (await db
            .collection('applied')
            .where('roomid', isEqualTo: roomId)
            .get())
        .docs
        .map((e) => e['uid'] as String)
        .where((uid) => uid != userId) // Avoid comparing the user with themselves
        .toList();

    if (roommates.isEmpty) {
      return -2; // The property is empty
    }

    double totalCompatibility = 0;
    for (String roommateId in roommates) {
      DocumentSnapshot roommateDoc = await db.collection('questionnaires').doc(roommateId).get();
      double compatibility = calculateSimilarity(
        userDoc.data() as Map<String, dynamic>,
        roommateDoc.data() as Map<String, dynamic>,
      );
      totalCompatibility += compatibility;
    }

    return roommates.isNotEmpty
        ? totalCompatibility / roommates.length
        : -1; // You are the only resident
  }

  double calculateSimilarity(Map<String, dynamic> user1, Map<String, dynamic> user2) {
    const fieldWeights = {
      'age': 0.05,
      'gender': 0.05,
      'nationality': 0.05,
      'languagesSpoken': 0.05,
      'jobTitle': 0.05,
      'cleanlinessLevel': 0.1,
      'introvertExtrovert': 0.1,
      'nightOwlOrEarlyBird': 0.05,
      'exerciseRoutine': 0.05,
      'dietaryPreferences': 0.05,
      'smoking': 0.05,
      'alcoholConsumption': 0.05,
      'noiseTolerance': 0.05,
      'preferredLocation': 0.05,
      'roomTemperature': 0.05,
      'roommateAgeRange': 0.05,
      'roommateCleanliness': 0.05,
      'roommateGender': 0.05,
      'roommateNationality': 0.05,
      'roommateOccupation': 0.05,
      'sharingFoodUtilities': 0.05,
      'socialInteraction': 0.05,
      'weekendActivities': 0.05,
      'workFromHomeFrequency': 0.05,
      'workSchedule': 0.05,
    };

    double totalScore = 0.0;
    double maxScore = 0.0;

    fieldWeights.forEach((field, weight) {
      if (user1.containsKey(field) && user2.containsKey(field)) {
        var value1 = user1[field];
        var value2 = user2[field];

        if (value1 == null || value2 == null) {
          return;
        }

        if (field == 'cleanlinessLevel' ||
            field == 'introvertExtrovert' ||
            field == 'noiseTolerance' ||
            field == 'roommateCleanliness') {
          double diff = (value1 - value2).abs();
          totalScore +=
              weight * (1 - (diff / 5.0)); // Range is 0-5 for these fields
        } else if (value1 is String && value2 is String) {
          if (value1 == value2) {
            totalScore += weight;
          }
        } else if (value1 is bool && value2 is bool) {
          if (value1 == value2) {
            totalScore += weight;
          }
        } else if (value1 is int && value2 is int) {
          double diff = (value1 - value2).abs() as double;
          totalScore +=
              weight * (1 - (diff / 100.0)); // Assuming age range is 0-100
        }
      }
      maxScore += weight;
    });

    return (totalScore / maxScore) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration:
          boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rfCommonCachedNetworkImage(widget.hotelData!.img.validate(),
                  height: 100, width: 100, fit: BoxFit.cover)
              .cornerRadiusWithClipRRect(8),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.hotelData!.name.validate(),
                          style: boldTextStyle()),
                      8.height,
                      Row(
                        children: [
                          Text("${widget.hotelData!.price.validate()} SAR",
                              style: boldTextStyle(color: rfPrimaryColor)),
                          4.width,
                          Text(widget.hotelData!.rentDuration.validate(),
                              style: secondaryTextStyle()),
                        ],
                      ).fit(),
                    ],
                  ).expand(),
                  Row(
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                      ),
                      6.width,
                      Text(widget.hotelData!.address.validate(),
                          style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ).paddingOnly(left: 3),
              widget.showHeight.validate() ? 8.height : 24.height,
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: rfPrimaryColor, size: 16),
                  6.width,
                  Text(widget.hotelData!.location.validate(),
                      style: secondaryTextStyle()),
                ],
              ),
              8.height,
              if (compatibilityMessage != null)
                Text(
                  compatibilityMessage!,
                  style: boldTextStyle(color: rfPrimaryColor),
                )
              else if (compatibilityPercentage != null)
                Text(
                  "Compatibility: ${compatibilityPercentage!.toStringAsFixed(2)}%",
                  style: boldTextStyle(color: rfPrimaryColor),
                ),
            ],
          ).expand()
        ],
      ),
    ).onTap(() {
      RFHotelDescriptionScreen(hotelData: widget.hotelData).launch(context);
    },
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent);
  }
}
