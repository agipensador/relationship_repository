import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required String super.name,
    required super.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id){
    return UserModel(
      id: id, 
      name: map['name'] ?? '', 
      email: map['email'] ?? '',
      );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}