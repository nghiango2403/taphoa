// To parse this JSON data, do
//
//     final thongKeDoanhThuModel = thongKeDoanhThuModelFromJson(jsonString);

import 'dart:convert';

ThongKeDoanhThuModel thongKeDoanhThuModelFromJson(String str) =>
    ThongKeDoanhThuModel.fromJson(json.decode(str));

String thongKeDoanhThuModelToJson(ThongKeDoanhThuModel data) =>
    json.encode(data.toJson());

class ThongKeDoanhThuModel {
  int status;
  String message;
  List<Datum2> data;

  ThongKeDoanhThuModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ThongKeDoanhThuModel.fromJson(Map<String, dynamic> json) =>
      ThongKeDoanhThuModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum2>.from(json["data"].map((x) => Datum2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum2 {
  DateTime id;
  int tongDoanhThu;
  int tongTienHang;
  int tongTienKhuyenMai;

  Datum2({
    required this.id,
    required this.tongDoanhThu,
    required this.tongTienHang,
    required this.tongTienKhuyenMai,
  });

  factory Datum2.fromJson(Map<String, dynamic> json) => Datum2(
    id: DateTime.parse(json["_id"]),
    tongDoanhThu: json["TongDoanhThu"],
    tongTienHang: json["TongTienHang"],
    tongTienKhuyenMai: json["TongTienKhuyenMai"],
  );

  Map<String, dynamic> toJson() => {
    "_id":
        "${id.year.toString().padLeft(4, '0')}-${id.month.toString().padLeft(2, '0')}-${id.day.toString().padLeft(2, '0')}",
    "TongDoanhThu": tongDoanhThu,
    "TongTienHang": tongTienHang,
    "TongTienKhuyenMai": tongTienKhuyenMai,
  };
}
