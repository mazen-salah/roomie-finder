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
  final _facilitiesController =
      TextEditingController(); // New controller for facilities
  late String rentDuration;
  late String selectedCity;
  File? mainImageFile;
  List<File> galleryImages = []; // New for gallery images
  bool _isLoading = false;
  double _uploadProgress = 0.0;

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

  Future<String> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef =
          storageRef.child('property_images/${DateTime.now()}.jpg');
      final uploadTask = imageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      await uploadTask;
      return await imageRef.getDownloadURL();
    } catch (e) {
      log("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading image: $e'),
      ));
      return '';
    }
  }

  Future<List<String>> _uploadGalleryImages() async {
    List<String> uploadedImageUrls = [];
    for (File image in galleryImages) {
      String imageUrl = await _uploadImage(image);
      if (imageUrl.isNotEmpty) {
        uploadedImageUrls.add(imageUrl);
      }
    }
    return uploadedImageUrls;
  }

  Future<void> _addProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final mainImageUrl = await _uploadImage(mainImageFile!);
        final galleryImageUrls = await _uploadGalleryImages();

        // Parse facilities input
        List<String> facilities =
            _facilitiesController.text.split(',').map((e) => e.trim()).toList();

        RoomModel roomModel = RoomModel(
          name: _nameController.text,
          price: _priceController.text,
          description: _descriptionController.text,
          location: selectedCity,
          img: mainImageUrl,
          images: galleryImageUrls,
          facilities: facilities,
          address: _addressController.text,
          rentDuration: rentDuration,
          owner: FirebaseAuth.instance.currentUser!.uid,
        );

        await FirebaseFirestore.instance
            .collection('rooms')
            .add(roomModel.toJson());

        Navigator.pop(context);
      } catch (e) {
        log("Error adding property: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickMainImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        mainImageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickGalleryImages() async {
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      if (pickedFiles != null) {
        galleryImages = pickedFiles.map((file) => File(file.path)).toList();
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
                  AppTextField(
                    controller: _facilitiesController,
                    textFieldType: TextFieldType.NAME,
                    decoration: rfInputDecoration(
                      lableText: "Facilities (Comma separated)",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the facilities';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  ElevatedButton.icon(
                    onPressed: _pickMainImage,
                    icon: const Icon(Icons.upload_file),
                    label: Text( 
                        mainImageFile == null ? 'Upload Main Image' : 'Image Selected'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickGalleryImages,
                    icon: const Icon(Icons.upload_file),
                    label: Text(
                        galleryImages.isEmpty ? 'Upload Gallery Images' : 'Images Selected'),
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
