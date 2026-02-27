// To parse this JSON data, do
//
//     final khuyenMaiTongModel = khuyenMaiTongModelFromJson(jsonString);

import 'dart:convert';

KhuyenMaiTongModel khuyenMaiTongModelFromJson(String str) => KhuyenMaiTongModel.fromJson(json.decode(str));

String khuyenMaiTongModelToJson(KhuyenMaiTongModel data) => json.encode(data.toJson());

class KhuyenMaiTongModel {
  int status;
  String message;
  Data data;

  KhuyenMaiTongModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KhuyenMaiTongModel.fromJson(Map<String, dynamic> json) => KhuyenMaiTongModel(
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
  int sotrang;

  Data({
    required this.danhsach,
    required this.sotrang,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    danhsach: List<Danhsach>.from(json["danhsach"].map((x) => Danhsach.fromJson(x))),
    sotrang: json["sotrang"],
  );

  Map<String, dynamic> toJson() => {
    "danhsach": List<dynamic>.from(danhsach.map((x) => x.toJson())),
    "sotrang": sotrang,
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
