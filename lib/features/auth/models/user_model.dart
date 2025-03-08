import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
