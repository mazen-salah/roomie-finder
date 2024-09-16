import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCongratulatedDialog.dart';
import 'package:roomie_finder/components/RFHotelDetailComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFHotelDescriptionScreen extends StatefulWidget {
  final RoomModel? hotelData;

  const RFHotelDescriptionScreen({
    super.key,
    this.hotelData,
  });

  @override
  State<RFHotelDescriptionScreen> createState() =>
      _RFHotelDescriptionScreenState();
}

class _RFHotelDescriptionScreenState extends State<RFHotelDescriptionScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppButton(
        color: rfPrimaryColor,
        elevation: 0,
        width: context.width(),
        onTap: () async {
          var existingApplication = await FirebaseFirestore.instance
              .collection('applied')
              .where('uid', isEqualTo: userModel!.id)
              .where('roomid', isEqualTo: widget.hotelData!.id)
              .get();

          if (existingApplication.docs.isEmpty) {
            await FirebaseFirestore.instance.collection('applied').add({
              'uid': userModel!.id,
              'roomid': widget.hotelData!.id,
            });
            showInDialog(
              context,
              barrierDismissible: true,
              builder: (context) {
                return const RFCongratulatedDialog();
              },
            );
          } else {
            toast('You have already applied for this room.');
          }
        },
        child: Text('Request', style: boldTextStyle(color: white)),
      ).paddingSymmetric(horizontal: 16, vertical: 24),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: white, size: 18),
                onPressed: () {
                  finish(context);
                },
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              backgroundColor: rfPrimaryColor,
              pinned: true,
              elevation: 2,
              expandedHeight: 300,
              flexibleSpace: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.hotelData!.images?.length ?? 1,
                    itemBuilder: (context, index) {
                      return rfCommonCachedNetworkImage(
                        widget.hotelData!.images?[index] ??
                            widget.hotelData!.img.validate(),
                        fit: BoxFit.cover,
                        width: context.width(),
                        height: 350,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.hotelData!.name.validate(),
                              style: boldTextStyle(color: white, size: 20)),
                          8.height,
                          Row(
                            children: [
                              Text("${widget.hotelData!.price.validate()} SAR",
                                  style: boldTextStyle(color: white)),
                              8.width,
                              Text(widget.hotelData!.rentDuration.validate(),
                                  style: secondaryTextStyle(color: white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RFHotelDetailComponent(hotelData: widget.hotelData),
            ],
          )
        ),
      ),
    );
  }
}
