class RoomModel {
  String? id ;
  String? img;
  String? name;
  String? description;
  String? address;
  String? price;
  String? rentDuration;
  String? location;
  String? reviews;
  String? owner;

  RoomModel({
    this.img = '',
    this.name = 'No Name',
    this.description = 'No Description',
    this.address = 'No Address',
    this.price = 'No Price',
    this.rentDuration = 'No Rent Duration',
    this.location = 'No Location',
    this.reviews = 'No reviews',
    this.owner = 'No Owner',
  });

  // Create a RoomModel from a Firestore document
  factory RoomModel.fromJson(Map<String, dynamic> map) {
    return RoomModel(
      img: map['img'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      address: map['address'] ?? '',
      price: map['price'] ?? '',
      rentDuration: map['rentDuration'] ?? '',
      location: map['location'] ?? '',
      reviews: map['reviews'] ?? '',
      owner: map['owner'] ?? '',
    );
  }

  // Convert a RoomModel to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'img': img,
      'name': name!.toLowerCase(),
      'description': description!.toLowerCase(),
      'address': address!.toLowerCase(),
      'price': price!.toLowerCase(),
      'rentDuration': rentDuration!.toLowerCase(),
      'location': location!.toLowerCase(),
      'reviews': reviews,
      'owner': owner,
    };
  }

  @override
  String toString() {
    return 'RoomModel(img: $img, name: $name, description: $description, address: $address, price: $price, rentDuration: $rentDuration, location: $location, reviews: $reviews, owner: $owner)';
  }
}
