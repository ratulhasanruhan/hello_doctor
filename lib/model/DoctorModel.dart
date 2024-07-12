// To parse this JSON data, do
//
//     final doctorModel = doctorModelFromJson(jsonString);

import 'dart:convert';

DoctorModel doctorModelFromJson(String str) => DoctorModel.fromJson(json.decode(str));

String doctorModelToJson(DoctorModel data) => json.encode(data.toJson());

class DoctorModel {
  DoctorModel({
    required this.name,
    required this.phone,
    required this.password,
    required this.experience,
    required this.avatar,
    required this.designation,
    required this.specialization,
    required this.approved,
    required this.active,
    required this.watched,
    required this.bio,
  });

  String name;
  String phone;
  String password;
  int experience;
  String avatar;
  String designation;
  List specialization;
  bool approved;
  bool active;
  int watched;
  String bio;

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
    name: json["name"],
    phone: json["phone"],
    password: json["password"],
    experience: json["experoence"],
    avatar: json["avatar"],
    designation: json["designation"],
    specialization: json["specialization"],
    approved: json["approved"],
    active: json["active"],
    watched: json["watched"],
    bio: json["bio"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "password": password,
    "experoence": experience,
    "avatar": avatar,
    "designation": designation,
    "specialization": specialization,
    "approved": approved,
    "active": active,
    "watched": watched,
    "bio": bio,
  };
}
