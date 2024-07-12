// To parse this JSON data, do
//
//     final healthCardModel = healthCardModelFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

HealthCardModel healthCardModelFromJson(String str) => HealthCardModel.fromJson(json.decode(str));

String healthCardModelToJson(HealthCardModel data) => json.encode(data.toJson());

class HealthCardModel {
  HealthCardModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.type,
    required this.photo,
    required this.nid,
    required this.doctor,
    required this.viewed,
    required this.date,
    required this.status,
    required this.lastDate,
  });

  String name;
  String phone;
  String address;
  String type;
  String photo;
  String nid;
  String doctor;
  int viewed;
  Timestamp date;
  String status;
  Timestamp lastDate;

  factory HealthCardModel.fromJson(Map<String, dynamic> json) => HealthCardModel(
    name: json["name"],
    phone: json["phone"],
    address: json["address"],
    type: json["type"],
    photo: json["photo"],
    nid: json["nid"],
    doctor: json["doctor"],
    viewed: json["viewed"],
    date: json["date"],
    status: json["status"],
    lastDate: json["lastDate"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "address": address,
    "type": type,
    "photo": photo,
    "nid": nid,
    "doctor": doctor,
    "viewed": viewed,
    "date": date,
    "status": status,
    "lastDate": lastDate,
  };
}
