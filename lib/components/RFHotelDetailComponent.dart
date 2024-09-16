import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/models/UserModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFDataGenerator.dart';
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
  final List<String> hotelImageData = hotelImageList();
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
    return Column(
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
    );
  }

  Widget buildOwnerInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            rfCommonCachedNetworkImage(ownerData!.profileImageUrl.validate(),
                    width: 60, height: 60, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(30),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ownerData!.fullName.validate(), style: boldTextStyle()),
                4.height,
                Text('Lessor', style: secondaryTextStyle()),
              ],
            ).expand(),
            AppButton(
              onTap: () {
                launchCall(ownerData!.phone.validate());
              },
              color: rfPrimaryColor,
              width: 15,
              height: 15,
              elevation: 0,
              child: rfCall.iconImage(iconColor: white, size: 14),
            ),
            8.width,
            AppButton(
              onTap: () {
                launchMail(ownerData!.email.validate());
              },
              color: rfPrimaryColor,
              width: 15,
              height: 15,
              elevation: 0,
              child: rfMessage.iconImage(iconColor: white, size: 14),
            ),
          ],
        ).paddingAll(24),
      ],
    );
  }

  Widget buildPropertyInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: rfPrimaryColor)
            .paddingOnly(top: 2),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.hotelData!.address.validate(), style: boldTextStyle()),
            8.height,
            Text('${widget.hotelData!.location}, Saudi Arabia',
                style: primaryTextStyle()),
            8.height,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add other relevant fields here, such as reviews
                Text(widget.hotelData!.reviews.validate(),
                    style: boldTextStyle(
                        color: appStore.isDarkModeOn ? white : rfTextColor))
              ],
            ),
          ],
        ).expand(),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Owned By: ${ownerData?.fullName ?? "Unknown"}',
              style: primaryTextStyle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ).paddingOnly(left: 2),
            8.height,
            Text(
              'View on Google Maps',
              style: primaryTextStyle(
                  color: appStore.isDarkModeOn ? white : rfTextColor,
                  decoration: TextDecoration.underline),
            ).paddingOnly(left: 2),
          ],
        ).expand()
      ],
    );
  }

  Widget buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: boldTextStyle()),
        8.height,
        Text(widget.hotelData!.description.validate(),
            style: secondaryTextStyle()),
      ],
    ).paddingOnly(left: 24, right: 24);
  }

  Widget buildFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Facilities', style: boldTextStyle()),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFacilityItem('1 Big Hall'),
                4.height,
                buildFacilityItem('Bikes and Car Parking'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFacilityItem('Shared Toilet'),
                4.height,
                buildFacilityItem('24/7 Water facility'),
              ],
            )
          ],
        ),
      ],
    ).paddingOnly(left: 24, right: 24);
  }

  Widget buildFacilityItem(String facility) {
    return Row(
      children: [
        const Icon(Icons.done, size: 16, color: rfPrimaryColor),
        8.width,
        Text(facility, style: secondaryTextStyle()),
      ],
    );
  }
}
