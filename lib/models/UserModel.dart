class UserModel {
  String? id;
  final String fullName; // Should be at least two words
  final String email;
  final String role; // Can be 'tenant' or 'lessor'
  final String profileImageUrl;
  final String location;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    this.id,
    required this.location,
    required this.phone,
    required this.fullName,
    required this.email,
    required this.role,
    this.profileImageUrl = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      location: json['location'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
      profileImageUrl: json['profileImageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'phone': phone,
      'updatedAt': updatedAt.toIso8601String(),
      'location': location,
    };
  }
}
