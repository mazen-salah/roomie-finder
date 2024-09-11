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

    List<RoomModel> roomList = snapshot.docs.map((doc) {
      RoomModel room = RoomModel.fromJson(doc.data() as Map<String, dynamic>);
      room.id = doc.id; // Assign the document ID to the RoomModel
      return room;
    }).toList();

    return roomList;
  }

  Future<List<LocationModel>> fetchLocationData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('locations').get();
    return snapshot.docs
        .map(
            (doc) => LocationModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
