import 'dart:convert';

import 'package:flutter_with_supabase/src/features/auth/domain/entity/user_entity.dart';

part 'user_model_ext.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.createdAt,
      required super.updatedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[_Json.id],
      name: json[_Json.name],
      email: json[_Json.email],
      createdAt: DateTime.parse(json[_Json.createdAt]),
      updatedAt: DateTime.parse(json[_Json.updatedAt]),
    );
  }

  // from raw json
  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  // from json list
  static List<UserModel> fromJsonList(List<Map<String, dynamic>> jsonList) =>
      jsonList.map((e) => UserModel.fromJson(e)).toList();

  // to json list
  static List<Map<String, dynamic>> toJsonList(List<UserModel> list,
          [bool sendApi = false]) =>
      list.map((e) => e.toJson()).toList();

  @override
  String toString() => toRawJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _Json {
  static const id = 'id';
  static const email = 'email';
  static const name = 'name';
  static const createdAt = 'created';
  static const updatedAt = 'updated';
}
