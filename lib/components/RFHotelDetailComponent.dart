import 'package:flutter/material.dart';
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
  bool isLoadingOwner = true; // Add a loading flag for owner data

  @override
  initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      UserModel? fetchedOwnerData = await RFAuthController()
          .fetchUserDataFromFirestore(widget.hotelData!.owner!);

      if (mounted) {
        setState(() {
          ownerData = fetchedOwnerData;
          isLoadingOwner = false;
        });
      }
    } catch (e) {
      // Handle the error and stop loading
      setState(() {
        isLoadingOwner = false;
      });
      toast('Failed to load owner data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owner Info Section
          isLoadingOwner
              ? const Center(child: CircularProgressIndicator())
              : ownerData != null
                  ? buildOwnerInfo(context)
                  : const Text('Owner data could not be loaded'),
          24.height,
          // Property Info Section
          buildPropertyInfo(context),
          24.height,
          // Description Section
          buildDescriptionSection(),
          24.height,
          // Facilities Section
          buildFacilitiesSection(),
        ],
      ),
    );
  }

  Widget buildOwnerInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
      ),
      child: Row(
        children: [
          rfCommonCachedNetworkImage(ownerData!.profileImageUrl.validate(),
                  width: 70, height: 70, fit: BoxFit.cover)
              .cornerRadiusWithClipRRect(35),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ownerData!.fullName.validate(),
                  style: boldTextStyle(size: 18)),
              4.height,
              Text('Lessor', style: secondaryTextStyle(size: 14)),
            ],
          ).expand(),
          16.width,
          Column(
            children: [
              AppButton(
                onTap: () {
                  launchCall(ownerData!.phone.validate());
                },
                color: rfPrimaryColor,
                elevation: 0,
                width: 40,
                height: 40,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: rfCall.iconImage(iconColor: white, size: 18),
              ),
              8.height,
              AppButton(
                onTap: () {
                  launchMail(ownerData!.email.validate());
                },
                color: rfPrimaryColor,
                elevation: 0,
                width: 40,
                height: 40,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: rfMessage.iconImage(iconColor: white, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPropertyInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              8.width,
              Text(widget.hotelData!.address.validate(),
                  style: boldTextStyle(size: 16)),
            ],
          ),
          8.height,
          Text('${widget.hotelData!.location}, Saudi Arabia',
              style: primaryTextStyle(size: 14)),
          16.height,
          Row(
            children: [
              Text('Reviews: ',
                  style: primaryTextStyle(
                      color: appStore.isDarkModeOn ? white : rfTextColor)),
              Text(widget.hotelData!.reviews.validate().toString(),
                  style: boldTextStyle(size: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: boldTextStyle(size: 18)),
          8.height,
          Text(widget.hotelData!.description.validate(),
              style: secondaryTextStyle(size: 14)),
        ],
      ),
    );
  }

  Widget buildFacilitiesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cardColor,
        boxShadow: defaultBoxShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Facilities', style: boldTextStyle(size: 18)),
          16.height,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
