import 'dart:convert';

KhuyenMaiThemModel khuyenMaiThemModelFromJson(String str) => KhuyenMaiThemModel.fromJson(json.decode(str));

String khuyenMaiThemModelToJson(KhuyenMaiThemModel data) => json.encode(data.toJson());

class KhuyenMaiThemModel {
  int status;
  String message;
  Data data;

  KhuyenMaiThemModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KhuyenMaiThemModel.fromJson(Map<String, dynamic> json) => KhuyenMaiThemModel(
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
  String tenKhuyenMai;
  DateTime ngayBatDau;
  DateTime ngayKetThuc;
  int tienKhuyenMai;
  int dieuKien;
  String id;
  int v;

  Data({
    required this.tenKhuyenMai,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.tienKhuyenMai,
    required this.dieuKien,
    required this.id,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tenKhuyenMai: json["TenKhuyenMai"],
    ngayBatDau: DateTime.parse(json["NgayBatDau"]),
    ngayKetThuc: DateTime.parse(json["NgayKetThuc"]),
    tienKhuyenMai: json["TienKhuyenMai"],
    dieuKien: json["DieuKien"],
    id: json["_id"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "TenKhuyenMai": tenKhuyenMai,
    "NgayBatDau": ngayBatDau.toIso8601String(),
    "NgayKetThuc": ngayKetThuc.toIso8601String(),
    "TienKhuyenMai": tienKhuyenMai,
    "DieuKien": dieuKien,
    "_id": id,
    "__v": v,
  };
}
