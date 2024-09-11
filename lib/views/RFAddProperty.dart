import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFWidget.dart';

class AddPropertyDialog extends StatefulWidget {
  const AddPropertyDialog({super.key});

  @override
  State<AddPropertyDialog> createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<AddPropertyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  late String rentDuration;
  late String selectedCity;
  File? imageFile;
  bool _isLoading = false; // For loading indicator
  double _uploadProgress = 0.0; // For upload progress percentage

  final picker = ImagePicker();
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

  final List<String> rentDurations = [
    'Per Day',
    'Per Week',
    'Per Month',
    'Per Year',
  ];

  @override
  void initState() {
    super.initState();
    selectedCity = cities.first;
    rentDuration = rentDurations.first;
  }

  Future<String> _uploadImage() async {
    if (imageFile == null) return '';

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef =
          storageRef.child('property_images/${DateTime.now()}.jpg');
      final uploadTask = imageRef.putFile(imageFile!);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      await uploadTask; // Wait until the file is uploaded

      return await imageRef.getDownloadURL();
    } catch (e) {
      log("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading image: $e'),
      ));
      return '';
    }
  }

  Future<void> _addProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        // Upload image and handle error
        final imageUrl = await _uploadImage();

        // Create RoomModel instance
        RoomModel roomModel = RoomModel(
          name: _nameController.text,
          price: _priceController.text,
          description: _descriptionController.text,
          location: selectedCity,
          img: imageUrl,
          address: _addressController.text,
          rentDuration: rentDuration,
          owner: FirebaseAuth.instance.currentUser!.uid,
        );

        // Try to add to Firestore
        await FirebaseFirestore.instance
            .collection('rooms')
            .add(roomModel.toJson());

        // Successfully added, close dialog
        Navigator.pop(context);
      } catch (e) {
        // Print error to console and show a Snackbar with the error
        log("Error adding property: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      } finally {
        // Stop loading in any case
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Add New Property', style: boldTextStyle(size: 18)),
                  16.height,
                  AppTextField(
                    controller: _nameController,
                    textFieldType: TextFieldType.NAME,
                    decoration: rfInputDecoration(
                      lableText: "Property Name",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a property name';
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
                      if (value == null || value.isEmpty) {
                        return 'Please select a city.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: _addressController,
                    textFieldType: TextFieldType.NAME,
                    decoration: rfInputDecoration(
                      lableText: "Address",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: _priceController,
                    textFieldType: TextFieldType.NUMBER,
                    decoration: rfInputDecoration(
                      lableText: "Price",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  DropdownButtonFormField<String>(
                    value: rentDuration,
                    onChanged: (newValue) {
                      setState(() {
                        rentDuration = newValue!;
                      });
                    },
                    items: rentDurations.map((duration) {
                      return DropdownMenuItem<String>(
                        value: duration,
                        child: Text(duration),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Rent Duration',
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
                      if (value == null || value.isEmpty) {
                        return 'Please select a rent duration.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: _descriptionController,
                    textFieldType: TextFieldType.MULTILINE,
                    maxLines: 3,
                    decoration: rfInputDecoration(
                      lableText: "Description",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: Text(
                        imageFile == null ? 'Upload Image' : 'Image Selected'),
                  ),
                  if (_uploadProgress > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(rfPrimaryColor),
                      ),
                    ),
                  32.height,
                  AppButton(
                    color: rfPrimaryColor,
                    width: context.width(),
                    height: 45,
                    onTap: _addProperty,
                    child: Text('Add Property',
                        style: boldTextStyle(color: white)),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
