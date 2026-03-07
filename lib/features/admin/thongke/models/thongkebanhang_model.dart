// To parse this JSON data, do
//
//     final thongKeBanHangModel = thongKeBanHangModelFromJson(jsonString);

import 'dart:convert';

ThongKeBanHangModel thongKeBanHangModelFromJson(String str) =>
    ThongKeBanHangModel.fromJson(json.decode(str));

String thongKeBanHangModelToJson(ThongKeBanHangModel data) =>
    json.encode(data.toJson());

class ThongKeBanHangModel {
  int status;
  String message;
  List<Datum1> data;

  ThongKeBanHangModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ThongKeBanHangModel.fromJson(Map<String, dynamic> json) =>
      ThongKeBanHangModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum1>.from(json["data"].map((x) => Datum1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum1 {
  int tongSoLuong;
  int tongTien;
  String maHangHoa;
  String tenHangHoa;

  Datum1({
    required this.tongSoLuong,
    required this.tongTien,
    required this.maHangHoa,
    required this.tenHangHoa,
  });

  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(
    tongSoLuong: json["TongSoLuong"],
    tongTien: json["TongTien"],
    maHangHoa: json["MaHangHoa"],
    tenHangHoa: json["TenHangHoa"],
  );

  Map<String, dynamic> toJson() => {
    "TongSoLuong": tongSoLuong,
    "TongTien": tongTien,
    "MaHangHoa": maHangHoa,
    "TenHangHoa": tenHangHoa,
  };
}
