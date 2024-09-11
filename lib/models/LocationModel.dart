import 'package:roomie_finder/utils/RFImages.dart';

class LocationModel {
  final String name;
  final String image;

  LocationModel({required this.name, required this.image});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image};
  }
}

List<LocationModel> locationList() {
  List<LocationModel> locationListData = [];
  locationListData.add(LocationModel(name: "Lalitpur", image: rfLocation1));
  locationListData.add(LocationModel(name: "Imadol", image: rfLocation2));
  locationListData.add(LocationModel(name: "Kupondole", image: rfLocation3));
  locationListData.add(LocationModel(name: "Lalitpur", image: rfLocation4));
  locationListData.add(LocationModel(name: "Mahalaxmi", image: rfLocation5));
  locationListData.add(LocationModel(name: "Koteshwor", image: rfLocation6));

  return locationListData;
}
