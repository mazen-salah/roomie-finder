class RoomModel {
  final String img;
  final String roomCategoryName;
  final String description;
  final String address;
  final String price;
  final String rentDuration;
  final String location;
  final int views;

  RoomModel({
    required this.img,
    required this.roomCategoryName,
    required this.description,
    required this.address,
    required this.price,
    required this.rentDuration,
    required this.location,
     this.views = 0,

  });

  // Create a RoomModel from a Firestore document
  factory RoomModel.fromJson(Map<String, dynamic> map) {
    return RoomModel(
      img: map['img'] ?? '',
      roomCategoryName: map['roomCategoryName'] ?? '',
      description: map['description'] ?? '',
      address: map['address'] ?? '',
      price: map['price'] ?? '',
      rentDuration: map['rentDuration'] ?? '',
      location: map['location'] ?? '',
      views: map['views'] ?? '',
     
    );
  }

  // Convert a RoomModel to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'img': img,
      'roomCategoryName': roomCategoryName,
      'description': description,
      'address': address,
      'price': price,
      'rentDuration': rentDuration,
      'location': location,
      'views': views,
    };
  }

  @override
  String toString() {
    return 'RoomModel(img: $img, roomCategoryName: $roomCategoryName, description: $description, address: $address, price: $price, rentDuration: $rentDuration, location: $location, views: $views)';
  }
}
