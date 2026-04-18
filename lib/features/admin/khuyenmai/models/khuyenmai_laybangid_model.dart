// To parse this JSON data, do
//
//     final khuyenMaiLayBangIdModel = khuyenMaiLayBangIdModelFromJson(jsonString);

import 'dart:convert';

KhuyenMaiLayBangIdModel khuyenMaiLayBangIdModelFromJson(String str) =>
    KhuyenMaiLayBangIdModel.fromJson(json.decode(str));

String khuyenMaiLayBangIdModelToJson(KhuyenMaiLayBangIdModel data) =>
    json.encode(data.toJson());

class KhuyenMaiLayBangIdModel {
  int status;
  String message;
  DataKhuyenMai data;

  KhuyenMaiLayBangIdModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KhuyenMaiLayBangIdModel.fromJson(Map<String, dynamic> json) =>
      KhuyenMaiLayBangIdModel(
        status: json["status"],
        message: json["message"],
        data: DataKhuyenMai.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class DataKhuyenMai {
  String id;
  String tenKhuyenMai;
  DateTime ngayBatDau;
  DateTime ngayKetThuc;
  int tienKhuyenMai;
  int dieuKien;
  int v;

  DataKhuyenMai({
    required this.id,
    required this.tenKhuyenMai,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.tienKhuyenMai,
    required this.dieuKien,
    required this.v,
  });

  factory DataKhuyenMai.fromJson(Map<String, dynamic> json) => DataKhuyenMai(
    id: json["_id"],
    tenKhuyenMai: json["TenKhuyenMai"],
    ngayBatDau: DateTime.parse(json["NgayBatDau"]),
    ngayKetThuc: DateTime.parse(json["NgayKetThuc"]),
    tienKhuyenMai: json["TienKhuyenMai"],
    dieuKien: json["DieuKien"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "TenKhuyenMai": tenKhuyenMai,
    "NgayBatDau": ngayBatDau.toIso8601String(),
    "NgayKetThuc": ngayKetThuc.toIso8601String(),
    "TienKhuyenMai": tienKhuyenMai,
    "DieuKien": dieuKien,
    "__v": v,
  };
}
