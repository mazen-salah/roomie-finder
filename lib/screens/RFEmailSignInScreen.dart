import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';
import 'package:roomie_finder/screens/RFHomeScreen.dart';
import 'package:roomie_finder/screens/RFResetPasswordScreen.dart';
import 'package:roomie_finder/screens/RFSignUpScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFString.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class RFEmailSignInScreen extends StatefulWidget {
  const RFEmailSignInScreen({super.key});

  @override
  State createState() => _RFEmailSignInScreenState();
}

class _RFEmailSignInScreenState extends State<RFEmailSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();

  Timer? timer;
  bool _isLoading = false; // Add this variable

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(rfPrimaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RFCommonAppComponent(
            title: rfAppName,
            subTitle: rfAppSubTitle,
            mainWidgetHeight: 250,
            subWidgetHeight: 190,
            cardWidget: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sign In', style: boldTextStyle(size: 18)),
                  16.height,
                  AppTextField(
                    controller: emailController,
                    focus: emailFocusNode,
                    nextFocus: passWordFocusNode,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: rfInputDecoration(
                      lableText: "Email Address",
                      showLableText: true,
                      suffixIcon: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          backgroundColor: rfRattingBgColor,
                        ),
                        child: const Icon(Icons.done,
                            color: Colors.white, size: 14),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: passwordController,
                    focus: passWordFocusNode,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: rfInputDecoration(
                      lableText: 'Password',
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password?', style: secondaryTextStyle())
                        .onTap(() {
                      const RFResetPasswordScreen().launch(context);
                    }),
                  ),
                  32.height,
                  AppButton(
                    color: rfPrimaryColor,
                    width: context.width(),
                    height: 45,
                    elevation: 0,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true; // Start loading
                        });

                        final response = await RFAuthController().signIn(
                          emailController.text,
                          passwordController.text,
                        );

                        setState(() {
                          _isLoading = false; // Stop loading
                        });

                        if (response['success']) {
                          _showSnackBar(context, response['message']);
                          const RFHomeScreen().launch(context, isNewTask: true);
                        } else {
                          _showSnackBar(context, response['message'],
                              isError: true);
                        }
                      }
                    },
                    child: Text('Sign In', style: boldTextStyle(color: white)),
                  ),
                  32.height,
                  Text('Don\'t have an account?',
                          style: primaryTextStyle(size: 16))
                      .center(),
                  8.height,
                  AppButton(
                    color: rfPrimaryColor,
                    width: context.width(),
                    height: 45,
                    elevation: 0,
                    onTap: () {
                      const RFSignUpScreen().launch(context);
                    },
                    child: Text('Create Account',
                        style: boldTextStyle(color: white)),
                  ),
                ],
              ),
            ),
            subWidget: rfCommonRichText(
                    title: "Don’t have an account? ",
                    subTitle: "Create one here")
                .paddingAll(8)
                .onTap(() {
              const RFSignUpScreen().launch(context);
            }),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(rfPrimaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
