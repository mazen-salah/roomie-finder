// controllers/RFHomeController.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:roomie_finder/models/RoomModel.dart';
import 'package:roomie_finder/models/LocationModel.dart';

class RFHomeController {
  final picker = ImagePicker();

  Future<List<RoomModel>> fetchRoomData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('rooms').get();
    return snapshot.docs
        .map((doc) => RoomModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<LocationModel>> fetchLocationData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('locations').get();
    return snapshot.docs
        .map(
            (doc) => LocationModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<File?> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String> uploadImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('property_images/${DateTime.now()}.jpg');
    await imageRef.putFile(imageFile);
    return await imageRef.getDownloadURL();
  }

  Future<void> addProperty(RoomModel roomModel) async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .add(roomModel.toJson());
  }
}
