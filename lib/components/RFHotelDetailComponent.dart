import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/models/UserModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';

class RFHotelDetailComponent extends StatefulWidget {
  final RoomModel? hotelData;

  const RFHotelDetailComponent({super.key, this.hotelData});

  @override
  State<RFHotelDetailComponent> createState() => _RFHotelDetailComponentState();
}

class _RFHotelDetailComponentState extends State<RFHotelDetailComponent> {
  UserModel? ownerData;
  bool isLoadingOwner = true;
  double? userReview;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<double> getCompatibilityPercentage(
      String roomId, String userId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot userDoc =
        await db.collection('questionnaires').doc(userId).get();
    List<String> allRoomMembers = (await db
            .collection('applied')
            .where('roomid', isEqualTo: roomId)
            .get())
        .docs
        .map((e) => e['uid'] as String)
        .toList();
    List<String> roommates =
        allRoomMembers.where((id) => id != userId).toList();

    if (allRoomMembers.isEmpty) {
      return -2; // The property is empty
    }

    double totalCompatibility = 0;
    for (String roommateId in roommates) {
      DocumentSnapshot roommateDoc =
          await db.collection('questionnaires').doc(roommateId).get();
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

  double calculateSimilarity(
      Map<String, dynamic> user1, Map<String, dynamic> user2) {
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

  Future<void> fetchUserData() async {
    try {
      UserModel? fetchedOwnerData = await RFAuthController()
          .fetchUserDataFromFirestore(widget.hotelData!.owner!);

      // Fetch the user's review if it exists
      final reviewQuery = await FirebaseFirestore.instance
          .collection('reviews')
          .where('roomid', isEqualTo: widget.hotelData!.id)
          .where('uid', isEqualTo: userModel!.id)
          .get();

      double? fetchedUserReview;
      if (reviewQuery.docs.isNotEmpty) {
        fetchedUserReview = reviewQuery.docs.first['review'];
      }

      if (mounted) {
        setState(() {
          ownerData = fetchedOwnerData;
          userReview = fetchedUserReview;
          isLoadingOwner = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingOwner = false;
      });
      toast('Failed to load owner data');
    }
  }

  Future<void> addReview(double rating) async {
    if (widget.hotelData == null) return;

    // Fetch the current user ID
    String userId =
        userModel!.id!; // Replace with actual method to get current user ID

    try {
      // Check if the user has already reviewed this room
      final reviewQuery = await FirebaseFirestore.instance
          .collection('reviews')
          .where('roomid', isEqualTo: widget.hotelData!.id)
          .where('uid', isEqualTo: userId)
          .get();

      if (reviewQuery.docs.isNotEmpty) {
        toast('You have already reviewed this room');
        return;
      }

      // If the user has not reviewed the room, add the review
      List<double> reviews = widget.hotelData!.reviews ?? [];
      reviews.add(rating);

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.hotelData!.id)
          .update({'reviews': reviews});

      // Add review to the reviews collection
      await FirebaseFirestore.instance.collection('reviews').add({
        'roomid': widget.hotelData!.id,
        'uid': userId,
        'review': rating,
      });

      setState(() {
        widget.hotelData!.reviews = reviews;
        userReview = rating;
      });

      toast('Review added successfully');
    } catch (e) {
      toast('Failed to add review');
    }
  }

  double calculateAverageReview(List<double>? reviews) {
    if (reviews == null || reviews.isEmpty) return 0.0;
    return reviews.reduce((a, b) => a + b) / reviews.length;
  }

  Widget buildReviewSection() {
    double averageReview = calculateAverageReview(widget.hotelData!.reviews);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews', style: boldTextStyle(size: 18)),
        const SizedBox(height: 8),
        averageReview == 0.0
            ? Text('No reviews yet', style: secondaryTextStyle(size: 14))
            : Row(
                children: [
                  Text(averageReview.toStringAsFixed(1),
                      style: boldTextStyle(size: 16)),
                  const SizedBox(width: 8),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
        const SizedBox(height: 16),
        RatingBar.builder(
          initialRating: userReview ?? 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) => addReview(rating),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoadingOwner
              ? const Center(child: CircularProgressIndicator())
              : buildOwnerInfo(),
          const SizedBox(height: 24),
          buildPropertyInfo(),
          const SizedBox(height: 24),
          buildDescriptionSection(),
          const SizedBox(height: 24),
          buildFacilitiesSection(),
          const SizedBox(height: 24),
          buildResidentsButton(),
        ],
      ),
    );
  }

  Widget buildOwnerInfo() {
    return ownerData == null
        ? const Text('Owner data could not be loaded')
        : Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.cardColor,
              boxShadow: defaultBoxShadow(),
            ),
            child: Row(
              children: [
                rfCommonCachedNetworkImage(
                        ownerData!.profileImageUrl.validate(),
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover)
                    .cornerRadiusWithClipRRect(35),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ownerData!.fullName.validate(),
                        style: boldTextStyle(size: 18)),
                    const SizedBox(height: 4),
                    Text('Lessor', style: secondaryTextStyle(size: 14)),
                  ],
                ).expand(),
                const SizedBox(width: 16),
                buildOwnerActionButtons(),
              ],
            ),
          );
  }

  Widget buildOwnerActionButtons() {
    return Column(
      children: [
        AppButton(
          onTap: () => launchCall(ownerData!.phone.validate()),
          color: rfPrimaryColor,
          elevation: 0,
          width: 40,
          height: 40,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: rfCall.iconImage(iconColor: white, size: 18),
        ),
        const SizedBox(height: 8),
        AppButton(
          onTap: () => launchMail(ownerData!.email.validate()),
          color: rfPrimaryColor,
          elevation: 0,
          width: 40,
          height: 40,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: rfMessage.iconImage(iconColor: white, size: 18),
        ),
      ],
    );
  }

  Widget buildPropertyInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: rfPrimaryColor),
              const SizedBox(width: 8),
              Text(widget.hotelData!.address.validate(),
                  style: boldTextStyle(size: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text('${widget.hotelData!.location}, Saudi Arabia',
              style: primaryTextStyle(size: 14)),
          const SizedBox(height: 16),
          FutureBuilder<double>(
            future: getCompatibilityPercentage(
                widget.hotelData!.id!, userModel!.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                double compatibility = snapshot.data ?? -1;
                String compatibilityText;
                Color compatibilityColor;

                if (compatibility == -2) {
                  compatibilityText = 'The property is empty';
                  compatibilityColor = Colors.grey;
                } else if (compatibility == -1) {
                  compatibilityText = 'You are the only resident';
                  compatibilityColor = Colors.blue;
                } else {
                  compatibilityText =
                      'Compatibility: ${compatibility.toStringAsFixed(1)}%';
                  compatibilityColor = compatibility >= 75
                      ? Colors.green
                      : (compatibility >= 50 ? Colors.orange : Colors.red);
                }

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: compatibilityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: compatibilityColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified_user, color: compatibilityColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          compatibilityText,
                          style: primaryTextStyle(
                              size: 14, color: compatibilityColor),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          buildReviewSection(),
        ],
      ),
    );
  }

  Widget buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: boldTextStyle(size: 18)),
          const SizedBox(height: 8),
          Text(widget.hotelData!.description.validate(),
              style: secondaryTextStyle(size: 14)),
        ],
      ),
    );
  }

  Widget buildFacilitiesSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Facilities', style: boldTextStyle(size: 18)),
          const SizedBox(height: 16),
          buildFacilitiesList(widget.hotelData!.facilities),
        ],
      ),
    );
  }

  Widget buildFacilitiesList(List<String>? facilities) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          facilities!.map((facility) => buildFacilityChip(facility)).toList(),
    );
  }

  Widget buildFacilityChip(String facility) {
    return Chip(
      avatar: const Icon(Icons.done, size: 16, color: rfPrimaryColor),
      label: Text(facility, style: secondaryTextStyle(size: 14)),
      backgroundColor: rfPrimaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget buildResidentsButton() {
    return AppButton(
      text: 'View Residents',
      color: rfPrimaryColor,
      textStyle: boldTextStyle(color: white),
      onTap: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Residents', style: boldTextStyle(size: 18)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          children: [
            SizedBox(
              width: double.maxFinite,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchResidentsData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No residents found');
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              'Total residents: ${snapshot.data!.length}',
                              style: boldTextStyle(size: 16),
                            ),
                          ),
                          ...snapshot.data!
                              .map((resident) => buildResidentTile(resident)),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResidentTile(Map<String, dynamic> resident) {
    return FutureBuilder<bool>(
      future: hasReviewedResident(resident['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool hasReviewed = snapshot.data ?? false;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: defaultBoxShadow(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(resident['name'], style: boldTextStyle(size: 16)),
                      Text(
                        'Compatibility: ${resident['compatibility']}%',
                        style: secondaryTextStyle(size: 14),
                      ),
                    ],
                  ),
                  if (!hasReviewed)
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) =>
                          reviewResident(resident['id'], rating),
                    )
                  else
                    Text('You have already reviewed this resident',
                        style: secondaryTextStyle(size: 14)),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchResidentsData() async {
    List<Map<String, dynamic>> residentsData = [];
    try {
      String roomId = widget.hotelData!.id.validate();
      String? userId = userModel!.id;

      List<String> allRoomMembers = (await FirebaseFirestore.instance
              .collection('applied')
              .where('roomid', isEqualTo: roomId)
              .get())
          .docs
          .map((e) => e['uid'] as String)
          .toList();

      for (String residentId in allRoomMembers) {
        if (residentId == userId) continue;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(residentId)
            .get();
        double compatibility =
            await getCompatibilityPercentage(roomId, residentId);
        residentsData.add({
          'id': residentId,
          'name': userDoc['fullName'],
          'compatibility': compatibility.toStringAsFixed(1),
        });
      }
    } catch (e) {
      log('Error fetching residents data: $e');
    }
    return residentsData;
  }

  Future<void> reviewResident(String residentId, double review) async {
    String? userId = userModel!.id;

    // Check if the user has already reviewed this resident
    bool hasReviewed = await hasReviewedResident(residentId);
    if (hasReviewed) {
      toast('You have already reviewed this resident');
      return;
    }

    // Save the review
    await FirebaseFirestore.instance.collection('reviews').add({
      'uid': userId,
      'roommateid': residentId,
      'review': review,
    });

    // Update the resident's average rating
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(residentId)
        .get();
    List<dynamic> reviews = userDoc['reviews'] ?? [];
    reviews.add(review);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(residentId)
        .update({'reviews': reviews});
  }

  Future<bool> hasReviewedResident(String residentId) async {
    String? userId = userModel!.id;

    QuerySnapshot reviewDocs = await FirebaseFirestore.instance
        .collection('reviews')
        .where('uid', isEqualTo: userId)
        .where('roommateid', isEqualTo: residentId)
        .get();

    return reviewDocs.docs.isNotEmpty;
  }
}
