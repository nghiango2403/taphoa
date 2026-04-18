// To parse this JSON data, do
//
//     final hoaDonXemChiTietModel = hoaDonXemChiTietModelFromJson(jsonString);

import 'dart:convert';

HoaDonXemChiTietModel hoaDonXemChiTietModelFromJson(String str) =>
    HoaDonXemChiTietModel.fromJson(json.decode(str));

String hoaDonXemChiTietModelToJson(HoaDonXemChiTietModel data) =>
    json.encode(data.toJson());

class HoaDonXemChiTietModel {
  int status;
  String message;
  List<Datum> data;

  HoaDonXemChiTietModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HoaDonXemChiTietModel.fromJson(Map<String, dynamic> json) =>
      HoaDonXemChiTietModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String maHoaDon;
  MaHangHoa maHangHoa;
  int soLuong;
  int donGia;
  int v;

  Datum({
    required this.id,
    required this.maHoaDon,
    required this.maHangHoa,
    required this.soLuong,
    required this.donGia,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    maHoaDon: json["MaHoaDon"],
    maHangHoa: MaHangHoa.fromJson(json["MaHangHoa"]),
    soLuong: json["SoLuong"],
    donGia: json["DonGia"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "MaHoaDon": maHoaDon,
    "MaHangHoa": maHangHoa.toJson(),
    "SoLuong": soLuong,
    "DonGia": donGia,
    "__v": v,
  };
}

class MaHangHoa {
  String id;
  String ten;
  int gia;
  int soLuong;
  int v;

  MaHangHoa({
    required this.id,
    required this.ten,
    required this.gia,
    required this.soLuong,
    required this.v,
  });

  factory MaHangHoa.fromJson(Map<String, dynamic> json) => MaHangHoa(
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
