import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';
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

  Future<void> fetchUserData() async {
    try {
      UserModel? fetchedOwnerData = await RFAuthController()
          .fetchUserDataFromFirestore(widget.hotelData!.owner!);

      // Fetch the current user ID
      String userId =
          'currentUserId'; // Replace with actual method to get current user ID

      // Fetch the user's review if it exists
      final reviewQuery = await FirebaseFirestore.instance
          .collection('reviews')
          .where('roomid', isEqualTo: widget.hotelData!.id)
          .where('uid', isEqualTo: userId)
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
        'currentUserId'; // Replace with actual method to get current user ID

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
}
