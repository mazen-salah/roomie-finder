import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCongratulatedDialog.dart';
import 'package:roomie_finder/components/RFHotelDetailComponent.dart';
import 'package:roomie_finder/models/RoomFinderModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFHotelDescriptionScreen extends StatefulWidget {
  final RoomFinderModel? hotelData;

  const RFHotelDescriptionScreen({super.key, this.hotelData});

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
  void setState(fn) {
    if (mounted) super.setState(fn);
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
        onTap: () {
          showInDialog(context, barrierDismissible: true, builder: (context) {
            return const RFCongratulatedDialog();
          });
        },
        child: Text('Book Now', style: boldTextStyle(color: white)),
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
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                titlePadding: const EdgeInsets.all(10),
                centerTitle: true,
                background: Stack(
                  children: [
                    rfCommonCachedNetworkImage(
                      widget.hotelData!.img.validate(),
                      fit: BoxFit.cover,
                      width: context.width(),
                      height: 350,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.hotelData!.roomCategoryName.validate(),
                              style: boldTextStyle(color: white, size: 18)),
                          8.height,
                          Row(
                            children: [
                              Text("${widget.hotelData!.price.validate()} ",
                                  style: boldTextStyle(color: white)),
                              Text(widget.hotelData!.rentDuration.validate(),
                                  style: secondaryTextStyle(color: white)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              RFHotelDetailComponent(hotelData: widget.hotelData),
            ],
          ),
        ),
      ),
    );
  }
}
