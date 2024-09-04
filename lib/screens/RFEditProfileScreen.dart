import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/components/RFCommonAppComponent.dart';
import 'package:roomie_finder/controllers/RFAuthController.dart';
import 'package:roomie_finder/main.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;

  bool _isLoading = false; // Add this variable

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: userModel!.fullName);
    _locationController = TextEditingController(text: userModel!.location);
    _phoneController = TextEditingController(text: userModel!.phone);
    init();
  }

  void init() async {
    setStatusBarColor(rfPrimaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      userModel!.fullName = _nameController.text;
      userModel!.location = _locationController.text;
      userModel!.phone = _phoneController.text;

      final response = await RFAuthController().updateUserData(userModel!);

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response['success']) {
        _showSnackBar(context, response['message']);
        Navigator.pop(context);
      } else {
        _showSnackBar(context, response['message'], isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RFCommonAppComponent(
            title: "Edit Profile",
            mainWidgetHeight: 250,
            cardWidget: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit Profile', style: boldTextStyle(size: 18)),
                  16.height,
                  AppTextField(
                    controller: _nameController,
                    textFieldType: TextFieldType.NAME,
                    decoration: rfInputDecoration(
                      lableText: "Full Name",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: _locationController,
                    textFieldType: TextFieldType.OTHER,
                    decoration: rfInputDecoration(
                      lableText: "Location",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: _phoneController,
                    textFieldType: TextFieldType.PHONE,
                    decoration: rfInputDecoration(
                      lableText: "Phone Number",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  32.height,
                  AppButton(
                    color: rfPrimaryColor,
                    width: context.width(),
                    height: 45,
                    elevation: 0,
                    onTap: _updateProfile,
                    child: Text('Save Changes',
                        style: boldTextStyle(color: white)),
                  ),
                ],
              ),
            ),
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
