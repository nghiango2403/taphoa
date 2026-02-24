// To parse this JSON data, do
//
//     final accountGetModel = accountGetModelFromJson(jsonString);

import 'dart:convert';

AccountGetModel accountGetModelFromJson(String str) =>
    AccountGetModel.fromJson(json.decode(str));

String accountGetModelToJson(AccountGetModel data) =>
    json.encode(data.toJson());

class AccountGetModel {
  int status;
  String message;
  Data data;

  AccountGetModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AccountGetModel.fromJson(Map<String, dynamic> json) =>
      AccountGetModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String hoTen;
  String sdt;
  String email;
  DateTime ngaySinh;
  String diaChi;
  String gioiTinh;
  int v;

  Data({
    required this.id,
    required this.hoTen,
    required this.sdt,
    required this.email,
    required this.ngaySinh,
    required this.diaChi,
    required this.gioiTinh,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    hoTen: json["HoTen"],
    sdt: json["SDT"],
    email: json["Email"],
    ngaySinh: DateTime.parse(json["NgaySinh"]),
    diaChi: json["DiaChi"],
    gioiTinh: json["GioiTinh"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "HoTen": hoTen,
    "SDT": sdt,
    "Email": email,
    "NgaySinh": ngaySinh.toIso8601String(),
    "DiaChi": diaChi,
    "GioiTinh": gioiTinh,
    "__v": v,
  };
}
