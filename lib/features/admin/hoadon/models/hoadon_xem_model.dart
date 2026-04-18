// To parse this JSON data, do
//
//     final hoaDonXemModel = hoaDonXemModelFromJson(jsonString);

import 'dart:convert';

HoaDonXemModel hoaDonXemModelFromJson(String str) =>
    HoaDonXemModel.fromJson(json.decode(str));

String hoaDonXemModelToJson(HoaDonXemModel data) => json.encode(data.toJson());

class HoaDonXemModel {
  int status;
  String message;
  Data data;

  HoaDonXemModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HoaDonXemModel.fromJson(Map<String, dynamic> json) => HoaDonXemModel(
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
  // Đổi kiểu dữ liệu trong List thành Item
  List<Item> danhsach;
  int soTrang;

  Data({required this.danhsach, required this.soTrang});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    // Key "danhsach" từ JSON vẫn giữ nguyên, nhưng map vào class Item
    danhsach: List<Item>.from(json["danhsach"].map((x) => Item.fromJson(x))),
    soTrang: json["soTrang"],
  );

  Map<String, dynamic> toJson() => {
    "danhsach": List<dynamic>.from(danhsach.map((x) => x.toJson())),
    "soTrang": soTrang,
  };
}

// Đổi tên class từ Danhsach thành Item
class Item {
  String id;
  MaNhanVien maNhanVien;
  DateTime ngayLap;
  String? maKhuyenMai;
  String hinhThucThanhToan;
  int v;

  Item({
    required this.id,
    required this.maNhanVien,
    required this.ngayLap,
    required this.maKhuyenMai,
    required this.hinhThucThanhToan,
    required this.v,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    dynamic nvData = json["MaNhanVien"];
    MaNhanVien finalMaNhanVien;

    if (nvData is String) {
      finalMaNhanVien = MaNhanVien(id: nvData, hoTen: "N/A");
    } else {
      finalMaNhanVien = MaNhanVien.fromJson(nvData);
    }
    return Item(
      id: json["_id"],
      maNhanVien: finalMaNhanVien,
      ngayLap: DateTime.parse(json["NgayLap"]),
      maKhuyenMai: json["MaKhuyenMai"],
      hinhThucThanhToan: json["HinhThucThanhToan"],
      v: json["__v"],
    );
  }

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
