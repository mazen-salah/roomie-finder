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
      name: "1 BHK at Lalitpur",
      price: "RS. 8000 / ",
      rentDuration: "per month",
      location: "Mahalaxmi Lalitpur",
      address: "Available",
      description: "9 Applied | ",
      reviews: "3.5"));
  hotelListData.add(RoomModel(
      img: rfHotel2,
      name: "Big Room",
      price: "RS. 5000 / ",
      rentDuration: "per day",
      location: "Imadol",
      address: "Unavailable",
      description: "5 Applied | ",
      reviews: "3.5"));
  hotelListData.add(RoomModel(
      img: rfHotel3,
      name: "4 Room for Student",
      price: "RS. 6000 / ",
      rentDuration: "per week",
      location: "Kupondole",
      address: "Available",
      description: "10 Applied | ",
      reviews: "3.5"));
  hotelListData.add(RoomModel(
      img: rfHotel4,
      name: "Hall and Room",
      price: "RS. 5000 / ",
      rentDuration: "per month",
      location: "Koteshwor Lalitpur",
      address: "Unavailable",
      description: "16 Applied | ",
      reviews: "3.5"));
  hotelListData.add(RoomModel(
      img: rfHotel5,
      name: "Big Room",
      price: "RS. 2000 / ",
      rentDuration: "per day",
      location: "Imadol",
      address: "Available",
      description: "9 Applied | ",
      reviews: "3.5"));
  hotelListData.add(RoomModel(
      img: rfHotel2,
      name: "Big Room",
      price: "RS. 5000 / ",
      rentDuration: "per day",
      location: "Imadol",
      address: "Unavailable",
      description: "5 Applied | ",
      reviews: "3.5"));

  return hotelListData;
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
      name: "1 BHK at Lalitpur",
      price: "RS 8000 ",
      rentDuration: "1.2 km from Gwarko",
      location: "Mahalaxmi Lalitpur",
      address: "Booked",
      reviews: "3",
      description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel2,
      name: "Big Room",
      price: "RS 5000 ",
      rentDuration: "1.2 km from Mahalaxmi",
      location: "Imadol",
      address: "Booked",
      reviews: "4",
      description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel3,
      name: "4 Room for Student",
      price: "RS 6000 ",
      rentDuration: "1.2 km from Imadol",
      location: "Kupondole",
      address: "Booked",
      reviews: "2",
      description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel4,
      name: "Hall and Room",
      price: "RS 5000 ",
      rentDuration: "1.2 km from Kupondole",
      location: "Koteshwor Lalitpur",
      address: "Booked",
      reviews: "4",
      description: ''));
  appliedHotelData.add(RoomModel(
      img: rfHotel5,
      name: "Big Room",
      price: "RS 2000 ",
      rentDuration: "1.2 km from Koteshwor",
      location: "Imadol",
      address: "Booked",
      reviews: "5",
      description: ''));

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
