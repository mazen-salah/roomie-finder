import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';
import 'package:roomie_finder/screens/RFEmailSignInScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFResetPasswordScreen extends StatefulWidget {
  const RFResetPasswordScreen({super.key});

  @override
  _RFResetPasswordScreenState createState() => _RFResetPasswordScreenState();
}

class _RFResetPasswordScreenState extends State<RFResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          showLeadingIcon: false,
          title: 'Reset Password',
          roundCornerShape: true,
          appBarHeight: 80),
      body: Column(
        children: [
          32.height,
          Text('Enter your email address below \nto reset password',
              style: secondaryTextStyle(height: 1.5),
              textAlign: TextAlign.center),
          16.height,
          AppTextField(
            controller: emailController,
            textFieldType: TextFieldType.EMAIL,
            decoration: rfInputDecoration(
              lableText: "Email Address",
              showLableText: true,
              suffixIcon: Container(
                padding: const EdgeInsets.all(2),
                decoration: boxDecorationWithRoundedCorners(
                    boxShape: BoxShape.circle, backgroundColor: redColor),
                child: const Icon(Icons.done, color: Colors.white, size: 14),
              ),
            ),
          ),
          32.height,
          AppButton(
            color: rfPrimaryColor,
            width: context.width(),
            elevation: 0,
            onTap: () {
              final response =
                  RFAuthController().resetPassword(emailController.text);
              response.then((value) {
                if (value['success']) {
                  _showSnackBar(context, value['message']);
                  finish(context);
                  const RFEmailSignInScreen().launch(context);
                } else {
                  _showSnackBar(context, value['message'], isError: true);
                }
              });
            },
            child: Text('Reset password', style: boldTextStyle(color: white)),
          ),
        ],
      ).paddingAll(24),
    );
  }
}
