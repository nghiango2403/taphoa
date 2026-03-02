import 'dart:convert';

NhanVienTongModel nhanVienTongModelFromJson(String str) => NhanVienTongModel.fromJson(json.decode(str));

String nhanVienTongModelToJson(NhanVienTongModel data) => json.encode(data.toJson());

class NhanVienTongModel {
  int status;
  String message;
  Data data;

  NhanVienTongModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NhanVienTongModel.fromJson(Map<String, dynamic> json) => NhanVienTongModel(
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

  Data({
    required this.danhsach,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    danhsach: List<Danhsach>.from(json["danhsach"].map((x) => Danhsach.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "danhsach": List<dynamic>.from(danhsach.map((x) => x.toJson())),
  };
}

class Danhsach {
  String id;
  String tenDangNhap;
  MaNhanSu maNhanSu;
  MaChucVu maChucVu;
  bool kichHoat;

  Danhsach({
    required this.id,
    required this.tenDangNhap,
    required this.maNhanSu,
    required this.maChucVu,
    required this.kichHoat,
  });

  factory Danhsach.fromJson(Map<String, dynamic> json) => Danhsach(
    id: json["_id"],
    tenDangNhap: json["TenDangNhap"],
    maNhanSu: MaNhanSu.fromJson(json["MaNhanSu"]),
    maChucVu: MaChucVu.fromJson(json["MaChucVu"]),
    kichHoat: json["KichHoat"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "TenDangNhap": tenDangNhap,
    "MaNhanSu": maNhanSu.toJson(),
    "MaChucVu": maChucVu.toJson(),
    "KichHoat": kichHoat,
  };
}

class MaChucVu {
  String id;
  String tenChucVu;
  int v;

  MaChucVu({
    required this.id,
    required this.tenChucVu,
    required this.v,
  });

  factory MaChucVu.fromJson(Map<String, dynamic> json) => MaChucVu(
    id: json["_id"],
    tenChucVu: json["TenChucVu"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "TenChucVu": tenChucVu,
    "__v": v,
  };
}

class MaNhanSu {
  String id;
  String hoTen;
  String gioiTinh;

  MaNhanSu({
    required this.id,
    required this.hoTen,
    required this.gioiTinh,
  });

  factory MaNhanSu.fromJson(Map<String, dynamic> json) => MaNhanSu(
    id: json["_id"],
    hoTen: json["HoTen"],
    gioiTinh: json["GioiTinh"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "HoTen": hoTen,
    "GioiTinh": gioiTinh,
  };
}
