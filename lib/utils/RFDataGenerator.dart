import 'package:roomie_finder/utils/RFImages.dart';

import '../models/RoomModel.dart';

List<String> categoryList() {
  List<String> categoryListData = [];
  categoryListData.add("Flat");
  categoryListData.add("Rooms");
  categoryListData.add("Hall");
  categoryListData.add("Rent");
  categoryListData.add("House");

  return categoryListData;
}

List<RoomModel> hotelList() {
  List<RoomModel> hotelListData = [];
  hotelListData.add(RoomModel(
      img: rfHotel1,
      roomCategoryName: "1 BHK at Lalitpur",
      price: "RS. 8000 / ",
      rentDuration: "per month",
      location: "Mahalaxmi Lalitpur",
      address: "Available",
      description: "9 Applied | ",
      views: 20));
  hotelListData.add(RoomModel(
      img: rfHotel2,
      roomCategoryName: "Big Room",
      price: "RS. 5000 / ",
      rentDuration: "per day",
      location: "Imadol",
      address: "Unavailable",
      description: "5 Applied | ",
      views: 10));
  hotelListData.add(RoomModel(
      img: rfHotel3,
      roomCategoryName: "4 Room for Student",
      price: "RS. 6000 / ",
      rentDuration: "per week",
      location: "Kupondole",
      address: "Available",
      description: "10 Applied | ",
      views: 6));
  hotelListData.add(RoomModel(
      img: rfHotel4,
      roomCategoryName: "Hall and Room",
      price: "RS. 5000 / ",
      rentDuration: "per month",
      location: "Koteshwor Lalitpur",
      address: "Unavailable",
      description: "16 Applied | ",
      views: 12));
  hotelListData.add(RoomModel(
      img: rfHotel5,
      roomCategoryName: "Big Room",
      price: "RS. 2000 / ",
      rentDuration: "per day",
      location: "Imadol",
      address: "Available",
      description: "9 Applied | ",
      views: 25));
  hotelListData.add(RoomModel(
      img: rfHotel2,
      roomCategoryName: "Big Room",
      price: "RS. 5000 / ",
      rentDuration: "per day",
      location: "Imadol",
      address: "Unavailable",
      description: "5 Applied | ",
      views: 10));

  return hotelListData;
}

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



class NotificationModel {
  final String price;
  final bool unReadNotification;
  final String description;

  NotificationModel({
    required this.price,
    required this.unReadNotification,
    required this.description,
  });
}

List<NotificationModel> notificationList() {
  List<NotificationModel> notificationListData = [];
  notificationListData.add(NotificationModel(
      price: "Welcome",
      unReadNotification: false,
      description: "Don’t forget to complete your personal info."));
  notificationListData.add(NotificationModel(
      price: "There are 4 available properties, you recently selected. ",
      unReadNotification: true,
      description: "Click here for more details."));

  return notificationListData;
}






List<String> applyHotelList() {
  List<String> applyHotelListData = [];
  applyHotelListData.add("Applied");
  applyHotelListData.add("Liked");

  return applyHotelListData;
}

List<String> availableHotelList() {
  List<String> availableHotelListData = [];
  availableHotelListData.add("All Available");
  availableHotelListData.add("Booked");

  return availableHotelListData;
}

List<RoomModel> appliedHotelList() {
  List<RoomModel> appliedHotelData = [];
  appliedHotelData.add(RoomModel(
      img: rfHotel1,
      roomCategoryName: "1 BHK at Lalitpur",
      price: "RS 8000 ",
      rentDuration: "1.2 km from Gwarko",
      location: "Mahalaxmi Lalitpur",
      address: "Booked",
      views: 3, description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel2,
      roomCategoryName: "Big Room",
      price: "RS 5000 ",
      rentDuration: "1.2 km from Mahalaxmi",
      location: "Imadol",
      address: "Booked",
      views: 4, description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel3,
      roomCategoryName: "4 Room for Student",
      price: "RS 6000 ",
      rentDuration: "1.2 km from Imadol",
      location: "Kupondole",
      address: "Booked",
      views: 2, description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel4,
      roomCategoryName: "Hall and Room",
      price: "RS 5000 ",
      rentDuration: "1.2 km from Kupondole",
      location: "Koteshwor Lalitpur",
      address: "Booked",
      views: 4, description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel5,
      roomCategoryName: "Big Room",
      price: "RS 2000 ",
      rentDuration: "1.2 km from Koteshwor",
      location: "Imadol",
      address: "Booked",
      views: 5, description: ''));

  return appliedHotelData;
}


List<String> hotelImageList() {
  List<String> hotelImageListData = [];
  hotelImageListData.add(rfHotel1);
  hotelImageListData.add(rfHotel2);
  hotelImageListData.add(rfHotel3);
  hotelImageListData.add(rfHotel4);

  return hotelImageListData;
}
