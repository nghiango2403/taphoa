// To parse this JSON data, do
//
//     final hangHoaTongModel = hangHoaTongModelFromJson(jsonString);

import 'dart:convert';

HangHoaTongModel hangHoaTongModelFromJson(String str) => HangHoaTongModel.fromJson(json.decode(str));

String hangHoaTongModelToJson(HangHoaTongModel data) => json.encode(data.toJson());

class HangHoaTongModel {
  int status;
  String message;
  List<Datum> data;

  HangHoaTongModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HangHoaTongModel.fromJson(Map<String, dynamic> json) => HangHoaTongModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String ten;
  int gia;
  int soLuong;
  int v;

  Datum({
    required this.id,
    required this.ten,
    required this.gia,
    required this.soLuong,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    ten: json["Ten"],
    gia: json["Gia"],
    soLuong: json["SoLuong"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Ten": ten,
    "Gia": gia,
    "SoLuong": soLuong,
    "__v": v,
  };
}
