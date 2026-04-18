// To parse this JSON data, do
//
//     final hoaDonThemModel = hoaDonThemModelFromJson(jsonString);

import 'dart:convert';

HoaDonThemModel hoaDonThemModelFromJson(String str) =>
    HoaDonThemModel.fromJson(json.decode(str));

String hoaDonThemModelToJson(HoaDonThemModel data) =>
    json.encode(data.toJson());

class HoaDonThemModel {
  int status;
  String message;
  Data data;

  HoaDonThemModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HoaDonThemModel.fromJson(Map<String, dynamic> json) =>
      HoaDonThemModel(
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
  List<ItemTHD> items;
  String maHoaDon;

  Data({required this.items, required this.maHoaDon});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    items: List<ItemTHD>.from(json["items"].map((x) => ItemTHD.fromJson(x))),
    maHoaDon: json["MaHoaDon"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "MaHoaDon": maHoaDon,
  };
}

class ItemTHD {
  String id;
  String maHoaDon;
  MaHangHoa maHangHoa;
  int soLuong;
  int donGia;
  int v;

  ItemTHD({
    required this.id,
    required this.maHoaDon,
    required this.maHangHoa,
    required this.soLuong,
    required this.donGia,
    required this.v,
  });

  factory ItemTHD.fromJson(Map<String, dynamic> json) => ItemTHD(
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
