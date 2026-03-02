import 'dart:convert';

NhapHangLayChiTietModel nhapHangLayChiTietModelFromJson(String str) =>
    NhapHangLayChiTietModel.fromJson(json.decode(str));

String nhapHangLayChiTietModelToJson(NhapHangLayChiTietModel data) =>
    json.encode(data.toJson());

class NhapHangLayChiTietModel {
  int status;
  String message;
  List<Datum> data;

  NhapHangLayChiTietModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NhapHangLayChiTietModel.fromJson(Map<String, dynamic> json) =>
      NhapHangLayChiTietModel(
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
  String maPhieuNhapHang;
  MaHangHoa maHangHoa;
  int soLuong;
  int tienHang;
  int v;

  Datum({
    required this.id,
    required this.maPhieuNhapHang,
    required this.maHangHoa,
    required this.soLuong,
    required this.tienHang,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    maPhieuNhapHang: json["MaPhieuNhapHang"],
    maHangHoa: MaHangHoa.fromJson(json["MaHangHoa"]),
    soLuong: json["SoLuong"],
    tienHang: json["TienHang"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "MaPhieuNhapHang": maPhieuNhapHang,
    "MaHangHoa": maHangHoa.toJson(),
    "SoLuong": soLuong,
    "TienHang": tienHang,
    "__v": v,
  };
}

class MaHangHoa {
  String id;
  String ten;
  int gia;

  MaHangHoa({required this.id, required this.ten, required this.gia});

  factory MaHangHoa.fromJson(Map<String, dynamic> json) =>
      MaHangHoa(id: json["_id"], ten: json["Ten"], gia: json["Gia"]);

  Map<String, dynamic> toJson() => {"_id": id, "Ten": ten, "Gia": gia};
}
