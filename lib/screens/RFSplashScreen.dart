import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';
import 'package:roomie_finder/screens/RFHomeScreen.dart';
import 'package:roomie_finder/screens/RFRoleSignInScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';

class RFSplashScreen extends StatefulWidget {
  const RFSplashScreen({super.key});

  @override
  State createState() => _RFSplashScreenState();
}

class _RFSplashScreenState extends State<RFSplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(rfPrimaryColor,
        statusBarIconBrightness: Brightness.light);

    await Future.delayed(const Duration(seconds: 2));
      finish(context);

      bool isUserSignedIn = RFAuthController().isSignedIn();

      if (isUserSignedIn) {
        const RFHomeScreen().launch(context);
      } else {
        const RFRoleSignIn().launch(context);
      }
    
  }

  @override
  void dispose() {
    setStatusBarColor(rfPrimaryColor,
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
      backgroundColor: rfPrimaryColor,
      body: Container(
        decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle, backgroundColor: rfSplashBgColor),
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
