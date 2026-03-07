// To parse this JSON data, do
//
//     final thongKeTonKhoModel = thongKeTonKhoModelFromJson(jsonString);

import 'dart:convert';

ThongKeTonKhoModel thongKeTonKhoModelFromJson(String str) =>
    ThongKeTonKhoModel.fromJson(json.decode(str));

String thongKeTonKhoModelToJson(ThongKeTonKhoModel data) =>
    json.encode(data.toJson());

class ThongKeTonKhoModel {
  int status;
  String message;
  List<Datum4> data;

  ThongKeTonKhoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ThongKeTonKhoModel.fromJson(Map<String, dynamic> json) =>
      ThongKeTonKhoModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum4>.from(json["data"].map((x) => Datum4.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum4 {
  String id;
  String ten;
  int gia;
  int soLuong;
  int v;

  Datum4({
    required this.id,
    required this.ten,
    required this.gia,
    required this.soLuong,
    required this.v,
  });

  factory Datum4.fromJson(Map<String, dynamic> json) => Datum4(
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
