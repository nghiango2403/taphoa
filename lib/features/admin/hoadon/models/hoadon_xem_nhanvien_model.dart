// To parse this JSON data, do
//
//     final hoaDonXemNhanVienModel = hoaDonXemNhanVienModelFromJson(jsonString);

import 'dart:convert';

HoaDonXemNhanVienModel hoaDonXemNhanVienModelFromJson(String str) =>
    HoaDonXemNhanVienModel.fromJson(json.decode(str));

String hoaDonXemNhanVienModelToJson(HoaDonXemNhanVienModel data) =>
    json.encode(data.toJson());

class HoaDonXemNhanVienModel {
  int status;
  String message;
  Data data;

  HoaDonXemNhanVienModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HoaDonXemNhanVienModel.fromJson(Map<String, dynamic> json) =>
      HoaDonXemNhanVienModel(
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
  int soTrang;

  Data({required this.danhsach, required this.soTrang});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    danhsach: List<Danhsach>.from(
      json["danhsach"].map((x) => Danhsach.fromJson(x)),
    ),
    soTrang: json["soTrang"],
  );

  Map<String, dynamic> toJson() => {
    "danhsach": List<dynamic>.from(danhsach.map((x) => x.toJson())),
    "soTrang": soTrang,
  };
}

class Danhsach {
  String id;
  MaNhanVien maNhanVien;
  DateTime ngayLap;
  String? maKhuyenMai;
  String hinhThucThanhToan;
  int v;

  Danhsach({
    required this.id,
    required this.maNhanVien,
    required this.ngayLap,
    required this.maKhuyenMai,
    required this.hinhThucThanhToan,
    required this.v,
  });

  factory Danhsach.fromJson(Map<String, dynamic> json) => Danhsach(
    id: json["_id"],
    maNhanVien: MaNhanVien.fromJson(json["MaNhanVien"]),
    ngayLap: DateTime.parse(json["NgayLap"]),
    maKhuyenMai: json["MaKhuyenMai"],
    hinhThucThanhToan: json["HinhThucThanhToan"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "MaNhanVien": maNhanVien.toJson(),
    "NgayLap": ngayLap.toIso8601String(),
    "MaKhuyenMai": maKhuyenMai,
    "HinhThucThanhToan": hinhThucThanhToan,
    "__v": v,
  };
}

class MaNhanVien {
  String id;
  String hoTen;

  MaNhanVien({required this.id, required this.hoTen});

  factory MaNhanVien.fromJson(Map<String, dynamic> json) =>
      MaNhanVien(id: json["_id"], hoTen: json["HoTen"]);

  Map<String, dynamic> toJson() => {"_id": id, "HoTen": hoTen};
}
