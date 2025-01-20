part of 'user_model.dart';

extension UserModelExt on UserModel {
  UserModel copWith(
      {String? id,
      String? name,
      String? email,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _Json.id: id,
      _Json.name: name,
      _Json.email: email,
      _Json.createdAt: createdAt.toUtc().toIso8601String(),
      _Json.updatedAt: updatedAt.toUtc().toIso8601String(),
    };
  }

  // to raw json
  String toRawJson() => json.encode(toJson());
}
