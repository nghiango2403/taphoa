// To parse this JSON data, do
//
//     final khuyenMaiXemConHoatDongModel = khuyenMaiXemConHoatDongModelFromJson(jsonString);

import 'dart:convert';

KhuyenMaiXemConHoatDongModel khuyenMaiXemConHoatDongModelFromJson(String str) =>
    KhuyenMaiXemConHoatDongModel.fromJson(json.decode(str));

String khuyenMaiXemConHoatDongModelToJson(KhuyenMaiXemConHoatDongModel data) =>
    json.encode(data.toJson());

class KhuyenMaiXemConHoatDongModel {
  int status;
  String message;
  Data data;

  KhuyenMaiXemConHoatDongModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KhuyenMaiXemConHoatDongModel.fromJson(Map<String, dynamic> json) =>
      KhuyenMaiXemConHoatDongModel(
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
  List<Danhsach> danhsach;

  Data({required this.danhsach});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    danhsach: List<Danhsach>.from(
      json["danhsach"].map((x) => Danhsach.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "danhsach": List<dynamic>.from(danhsach.map((x) => x.toJson())),
  };
}

class Danhsach {
  String id;
  String tenKhuyenMai;
  DateTime ngayBatDau;
  DateTime ngayKetThuc;
  int tienKhuyenMai;
  int dieuKien;
  int v;

  Danhsach({
    required this.id,
    required this.tenKhuyenMai,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.tienKhuyenMai,
    required this.dieuKien,
    required this.v,
  });

  factory Danhsach.fromJson(Map<String, dynamic> json) => Danhsach(
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
