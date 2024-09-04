import 'package:roomie_finder/utils/RFImages.dart';

class LocationData {
  final String name;
  final String image;

  LocationData({required this.name, required this.image});
}

List<LocationData> locationList() {
  List<LocationData> locationListData = [];
  locationListData.add(LocationData(name: "Lalitpur", image: rfLocation1));
  locationListData.add(LocationData(name: "Imadol", image: rfLocation2));
  locationListData.add(LocationData(name: "Kupondole", image: rfLocation3));
  locationListData.add(LocationData(name: "Lalitpur", image: rfLocation4));
  locationListData.add(LocationData(name: "Mahalaxmi", image: rfLocation5));
  locationListData.add(LocationData(name: "Koteshwor", image: rfLocation6));

  return locationListData;
}
