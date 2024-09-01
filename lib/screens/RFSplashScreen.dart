import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/screens/RFRoleSignInScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';

class RFSplashScreen extends StatefulWidget {
  @override
  _RFSplashScreenState createState() => _RFSplashScreenState();
}

class _RFSplashScreenState extends State<RFSplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);

    await Future.delayed(Duration(seconds: 2));
    finish(context);
    RFRoleSignIn().launch(context);
  }

  @override
  void dispose() {
    setStatusBarColor(rf_primaryColor,
        statusBarIconBrightness: Brightness.light);

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rf_primaryColor,
      body: Container(
        decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle, backgroundColor: rf_splashBgColor),
        width: 250,
        height: 250,
        child: ClipOval(
          child: Image.asset(
            'images/app_logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ).center(),
    );
  }
}
