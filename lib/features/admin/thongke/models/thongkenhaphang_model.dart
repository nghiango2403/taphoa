// To parse this JSON data, do
//
//     final thongKeNhapHangModel = thongKeNhapHangModelFromJson(jsonString);

import 'dart:convert';

ThongKeNhapHangModel thongKeNhapHangModelFromJson(String str) =>
    ThongKeNhapHangModel.fromJson(json.decode(str));

String thongKeNhapHangModelToJson(ThongKeNhapHangModel data) =>
    json.encode(data.toJson());

class ThongKeNhapHangModel {
  int status;
  String message;
  List<Datum3> data;

  ThongKeNhapHangModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ThongKeNhapHangModel.fromJson(Map<String, dynamic> json) =>
      ThongKeNhapHangModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum3>.from(json["data"].map((x) => Datum3.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum3 {
  int tongSoLuong;
  int tongTien;
  String maHangHoa;
  String tenHangHoa;

  Datum3({
    required this.tongSoLuong,
    required this.tongTien,
    required this.maHangHoa,
    required this.tenHangHoa,
  });

  factory Datum3.fromJson(Map<String, dynamic> json) => Datum3(
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
