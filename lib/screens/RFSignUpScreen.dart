import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';
import 'package:roomie_finder/models/UserModel.dart';
import 'package:roomie_finder/screens/RFEmailSignInScreen.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';
import '../utils/RFString.dart';

class RFSignUpScreen extends StatefulWidget {
  const RFSignUpScreen({super.key});

  @override
  State<RFSignUpScreen> createState() => _RFSignUpScreenState();
}

class _RFSignUpScreenState extends State<RFSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  String role = "tenant";
  String selectedCity = "Riyadh";
  bool _isLoading = false; // Add this variable

  final List<String> cities = [
    "Riyadh",
    "Jeddah",
    "Dammam",
    "Khobar",
    "Mecca",
    "Medina",
    "Abha",
    "Tabuk",
    "Hail",
    "Jizan",
    "Najran",
    "Buraidah"
  ];

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
      body: Stack(
        children: [
          RFCommonAppComponent(
            title: rfAppName,
            subTitle: rfAppSubTitle,
            mainWidgetHeight: 250,
            subWidgetHeight: 220,
            cardWidget: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Create an Account', style: boldTextStyle(size: 18)),
                  16.height,
                  AppTextField(
                    controller: fullNameController,
                    focus: fullNameFocusNode,
                    nextFocus: emailFocusNode,
                    textFieldType: TextFieldType.NAME,
                    decoration: rfInputDecoration(
                      lableText: "Full Name",
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
                      if (value == null || value.split(' ').length < 2) {
                        return 'Please enter at least 2 words.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: emailController,
                    focus: emailFocusNode,
                    nextFocus: phoneFocusNode,
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
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: phoneController,
                          focus: phoneFocusNode,
                          nextFocus: passWordFocusNode,
                          textFieldType: TextFieldType.PHONE,
                          decoration: rfInputDecoration(
                            lableText: 'Phone Number',
                            showLableText: true,
                            prefixText: '+966 ',
                            showPrefixText: true,
                          ),
                          validator: (value) {
                            if (value == null || value.length < 10) {
                              return 'Please enter a valid phone number.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  AppTextField(
                    controller: passwordController,
                    focus: passWordFocusNode,
                    nextFocus: confirmPasswordFocusNode,
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
                  AppTextField(
                    controller: confirmPasswordController,
                    focus: confirmPasswordFocusNode,
                    
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: rfInputDecoration(
                      lableText: 'Confirm Password',
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCity = newValue!;
                      });
                    },
                    items: cities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Select City',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a city.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  Text("Choose your role", style: boldTextStyle(size: 24)),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton(
                        color: role == "tenant" ? rfPrimaryColor : Colors.white,
                        child: Column(
                          children: [
                            Image.asset("images/tenant.png", height: 50),
                            Text("Tenant", style: boldTextStyle(size: 16)),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            role = "tenant";
                          });
                        },
                      ),
                      16.width,
                      AppButton(
                        color: role == "lessor" ? rfPrimaryColor : Colors.white,
                        child: Column(
                          children: [
                            Image.asset("images/lessor.png", height: 50),
                            Text("Lessor", style: boldTextStyle(size: 16)),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            role = "lessor";
                          });
                        },
                      ),
                    ],
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

                        final response = await RFAuthController().signUp(
                          UserModel(
                            fullName: fullNameController.text,
                            email: emailController.text,
                            role: role,
                            phone: phoneController.text,
                            location: selectedCity,
                          ),
                          passwordController.text,
                        );

                        setState(() {
                          _isLoading = false; // Stop loading
                        });

                        if (response['success']) {
                          if (mounted) {
                            _showSnackBar(context, response['message']);
                          }
                          if (mounted) {
                            const RFEmailSignInScreen().launch(context);
                          }
                        } else {
                          if (mounted) {
                            _showSnackBar(context, response['message'],
                                isError: true);
                          }
                        }
                      }
                    },
                    child: Text('Create Account',
                        style: boldTextStyle(color: white)),
                  ),
                ],
              ),
            ),
            subWidget: rfCommonRichText(
                    title: "Have an account? ", subTitle: "Sign In Here")
                .paddingAll(8)
                .onTap(() {
              finish(context);
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
