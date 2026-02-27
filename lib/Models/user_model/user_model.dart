// models/user_model.dart

class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;
  final String street;
  final String zipcode;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
    required this.street,
    required this.zipcode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    email: json['email'] as String,
    username: json['username'] as String,
    firstName: json['name']['firstname'] as String,
    lastName: json['name']['lastname'] as String,
    phone: json['phone'] as String,
    city: json['address']['city'] as String,
    street: json['address']['street'] as String,
    zipcode: json['address']['zipcode'] as String,
  );

  String get fullName => '${firstName[0].toUpperCase()}${firstName.substring(1)} ''${lastName[0].toUpperCase()}${lastName.substring(1)}';

  String get initials => '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
}