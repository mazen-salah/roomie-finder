import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/screens/RFEmailSignInScreen.dart';
import 'package:roomie_finder/screens/RFResetPasswordScreen.dart';
import 'package:roomie_finder/screens/RFSignUpScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFString.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import 'package:roomie_finder/utils/codePicker/country_code_picker.dart';

class RFRoleSignIn extends StatefulWidget {
  @override
  _RFRoleSignInState createState() => _RFRoleSignInState();
}

class _RFRoleSignInState extends State<RFRoleSignIn> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // setStatusBarColor(rf_primaryColor, statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    changeStatusColor(appStore.scaffoldBackground!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RFCommonAppComponent(
          title: RFAppName,
          subTitle: RFAppSubTitle,
          cardWidget: Column(
            children: [
              Text("Choose your role", style: boldTextStyle(size: 24)),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoleButton(
                    image: "images/tenant.png",
                    text: "Tenant",
                    onTap: () {
                      RFEmailSignInScreen().launch(context);
                    },
                  ),
                  _buildRoleButton(
                    image: "images/lessor.png",
                    text: "Lessor",
                    onTap: () {
                      RFEmailSignInScreen().launch(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          subWidget: socialLoginWidget(
            context,
            title1: "New Member? ",
            title2: "Sign up Here",
            callBack: () {
              RFSignUpScreen().launch(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String image,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      width: context.width() * 0.35,
      child: AppButton(
        child: Column(
          children: [
            Image.asset(image, height: 50),
            Text(text, style: boldTextStyle(size: 16)),
          ],
        ),
        text: text,
        onTap: onTap,
      ),
    );
  }
}